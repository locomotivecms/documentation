#!/usr/bin/env ruby

# README.com to Sitepress Markdown Migration Script
#
# Reads local README.com export files, transforms syntax, downloads images,
# and outputs Sitepress-compatible markdown pages.
#
# Usage:
#   ruby scripts/migrate_readme.rb -i readme-exports/locomotive-v3-v4.0 -o pages
#   ruby scripts/migrate_readme.rb -i readme-exports/locomotive-v3-v3.3 -o pages/v3
#
# Options:
#   -i, --input DIR    Input directory (README.com export root, contains docs/ folder)
#   -o, --output DIR   Output directory for Sitepress markdown files
#   -d, --download     Download remote images (default: false, just rewrite paths)
#   --dry-run          Show what would be done without writing files

require 'fileutils'
require 'optparse'
require 'yaml'
require 'open-uri'
require 'cgi'
require 'json'
require 'nokogiri'

IMG_OUTPUT_DIR = './assets/images'

# ─── Markdown Transformations ───────────────────────────────────────────────────

module Transformations
  module_function

  # Convert README.com callout blockquotes to {% hint %} Liquid tags.
  #
  # Input format:
  #   > 📘 Optional Title
  #   >
  #   > Content here
  #   > more content
  #
  # Output format:
  #   {% hint style="info" %}
  #   **Optional Title**
  #
  #   Content here
  #   more content
  #   {% endhint %}
  EMOJI_MAP = {
    '📘' => 'info',
    '🚧' => 'warning',
    '❗️' => 'warning',
    '❗' => 'warning',
    '👍' => 'success',
  }

  def convert_callouts(body)
    lines = body.lines
    result = []
    i = 0

    while i < lines.length
      # Check if this line starts a blockquote
      if lines[i] =~ /^>\s?/
        # Collect all lines of this blockquote block
        bq_lines = []
        while i < lines.length && lines[i] =~ /^>/
          # Strip the > prefix (and optional space)
          bq_lines << lines[i].sub(/^>\s?/, '')
          i += 1
        end

        # Check if first line contains a callout emoji
        first_content = bq_lines.first&.strip || ''
        matched_emoji = EMOJI_MAP.keys.find { |e| first_content.start_with?(e) }

        if matched_emoji
          style = EMOJI_MAP[matched_emoji]
          title = first_content.sub(matched_emoji, '').strip

          # Get content lines (skip first line and any blank line after it)
          content_lines = bq_lines[1..]
          content_lines.shift if content_lines&.first&.strip&.empty?
          content = (content_lines || []).join.strip

          result << "{% hint style=\"#{style}\" %}\n"
          result << "**#{title}**\n\n" unless title.empty?
          result << "#{content}\n" unless content.empty?
          result << "{% endhint %}\n"
          result << "\n"
        else
          # Regular blockquote, keep as-is
          bq_lines.each { |l| result << "> #{l}" }
        end
      else
        result << lines[i]
        i += 1
      end
    end

    result.join
  end

  # Convert code blocks with titles from README.com format to {% code %} tags.
  #
  # Input format:
  #   ```ruby Gemfile
  #   code here
  #   ```
  #
  # Output format:
  #   {% code title="Gemfile" %}
  #   ```ruby
  #   code here
  #   ```
  #   {% endcode %}
  #
  # Also detects consecutive titled code blocks and converts them to tabs.
  def convert_code_blocks(body)
    # First pass: detect and mark consecutive titled code blocks as tab groups
    lines = body.lines
    result = []
    i = 0

    while i < lines.length
      # Check if this line starts a code block with a title
      if lines[i] =~ /^```(\w+)\s+(.+)$/
        # Collect consecutive titled code blocks
        group = []
        while i < lines.length && lines[i] =~ /^```(\w+)\s+(.+)$/
          lang = $1
          title = $2.strip
          code_lines = []
          i += 1

          # Collect code content until closing ```
          while i < lines.length && lines[i].rstrip != '```'
            code_lines << lines[i]
            i += 1
          end
          i += 1 if i < lines.length # skip closing ```

          group << { lang: lang, title: title, code: code_lines.join }

          # Skip blank lines between consecutive code blocks
          blank_count = 0
          while i < lines.length && lines[i].strip.empty?
            blank_count += 1
            i += 1
          end

          # If next line is not another titled code block, put blank lines back
          unless i < lines.length && lines[i] =~ /^```(\w+)\s+(.+)$/
            i -= blank_count
            break
          end
        end

        if group.length > 1
          # Multiple consecutive titled blocks → tabs
          result << "{% tabs %}\n"
          group.each do |block|
            result << "{% tab title=\"#{block[:title]}\" %}\n"
            result << "```#{normalize_language(block[:lang])}\n"
            result << block[:code]
            result << "```\n"
            result << "{% endtab %}\n"
          end
          result << "{% endtabs %}\n"
        elsif group.length == 1
          # Single titled code block → {% code %} tag
          block = group.first
          result << "{% code title=\"#{block[:title]}\" %}\n"
          result << "```#{normalize_language(block[:lang])}\n"
          result << block[:code]
          result << "```\n"
          result << "{% endcode %}\n"
        end
      else
        result << lines[i]
        i += 1
      end
    end

    result.join
  end

  # Normalize language identifiers
  def normalize_language(lang)
    case lang.downcase
    when 'text' then '' # plain text, no highlighting
    else lang.downcase
    end
  end

  # Convert <Table> JSX components to standard markdown tables.
  #
  # Input: <Table align={["left","left"]}><thead>...</thead><tbody>...</tbody></Table>
  # Output: | Header | Header |
  #         | :--- | :--- |
  #         | Cell | Cell |
  def convert_html_tables(body)
    body.gsub(/<Table[^>]*>.*?<\/Table>/m) do |table_html|
      convert_single_table(table_html)
    end
  end

  def convert_single_table(html)
    doc = Nokogiri::HTML.fragment(html)
    table = doc.at('table') || doc

    rows = []
    headers = []

    # Extract headers
    table.css('thead tr th, thead tr td').each do |th|
      headers << clean_cell_text(th)
    end

    # Extract body rows
    table.css('tbody tr').each do |tr|
      row = tr.css('td').map { |td| clean_cell_text(td) }
      rows << row
    end

    return html if headers.empty? && rows.empty?

    # Build markdown table
    col_count = [headers.length, rows.map(&:length).max || 0].max
    headers = headers + [''] * (col_count - headers.length) if headers.length < col_count

    result = "| #{headers.join(' | ')} |\n"
    result += "| #{headers.map { ':---' }.join(' | ')} |\n"
    rows.each do |row|
      row = row + [''] * (col_count - row.length) if row.length < col_count
      result += "| #{row.join(' | ')} |\n"
    end

    result
  end

  def clean_cell_text(node)
    # Get inner HTML, convert to text, clean up
    text = node.inner_html
      .gsub(/<br\s*\/?>/, '<br/>')
      .gsub(/<[^>]+>/, '') # Strip remaining HTML tags
      .gsub(/\s+/, ' ')
      .gsub("\\\n", ' ')
      .strip

    # Unescape HTML entities
    CGI.unescapeHTML(text)
  end

  # Convert <Image> JSX components to standard markdown images.
  #
  # Input: <Image title="name.png" alt="123" src="https://..." />
  # or:    <Image src="https://..." align="center">Caption</Image>
  # Output: ![alt](local/path.png)
  def convert_image_components(body, page_slug)
    # Self-closing: <Image ... />
    body = body.gsub(/<Image\s+([^>]*?)\/>/m) do |match|
      attrs = parse_attributes($1)
      src = attrs['src'] || ''
      alt = attrs['alt'] || attrs['title'] || ''
      convert_image_reference(src, alt, page_slug)
    end

    # With content: <Image ...>content</Image>
    body = body.gsub(/<Image\s+([^>]*?)>(.*?)<\/Image>/m) do |match|
      attrs = parse_attributes($1)
      src = attrs['src'] || ''
      alt = attrs['alt'] || attrs['title'] || $2.strip
      convert_image_reference(src, alt, page_slug)
    end

    body
  end

  # Convert standard markdown images with remote URLs to local paths.
  def convert_markdown_images(body, page_slug)
    body.gsub(/!\[([^\]]*)\]\(([^)]+)\)/) do |match|
      alt = $1
      url = $2.split('"').first.strip # Remove title part

      if url.start_with?('http')
        convert_image_reference(url, alt, page_slug)
      else
        match # Keep local references as-is
      end
    end
  end

  def convert_image_reference(url, alt, page_slug)
    return "![#{alt}](#{url})" if url.empty? || !url.start_with?('http')

    ext = File.extname(URI.parse(url.split('?').first).path)
    ext = '.png' if ext.empty?

    # Generate a local filename from the URL
    filename = File.basename(URI.parse(url.split('?').first).path)
      .gsub(/[^a-zA-Z0-9._-]/, '-')
      .gsub(/-+/, '-')
    local_path = "pages/#{page_slug}/#{filename}"

    $images_to_download ||= []
    $images_to_download << { url: url, local_path: local_path }

    "![#{alt}](#{local_path})"
  end

  def parse_attributes(attr_string)
    attrs = {}
    attr_string.scan(/(\w+)="([^"]*)"/).each do |key, value|
      attrs[key] = value
    end
    attrs
  end

  # Convert <HTMLBlock> components (video embeds, etc.)
  def convert_html_blocks(body)
    body.gsub(/<HTMLBlock>\{\`\n?(.*?)\n?\`\}<\/HTMLBlock>/m) do |match|
      html_content = $1.strip
      # For Wistia embeds, create a simple embed wrapper
      if html_content.include?('wistia')
        wistia_match = html_content.match(/wistia_async_(\w+)/)
        wistia_id = wistia_match && wistia_match[1]
        if wistia_id
          <<~HTML
          <div class="wistia-embed">
          <script src="https://fast.wistia.com/embed/medias/#{wistia_id}.jsonp" async></script>
          <script src="https://fast.wistia.com/assets/external/E-v1.js" async></script>
          <div class="wistia_responsive_padding" style="padding:56.25% 0 0 0;position:relative;">
          <div class="wistia_responsive_wrapper" style="height:100%;left:0;position:absolute;top:0;width:100%;">
          <div class="wistia_embed wistia_async_#{wistia_id} videoFoam=true" style="height:100%;position:relative;width:100%"></div>
          </div>
          </div>
          </div>
          HTML
        else
          html_content
        end
      else
        html_content
      end
    end
  end

  # Rewrite internal links to match new URL structure.
  #
  # Patterns to handle:
  #   https://doc.locomotivecms.com/docs/slug
  #   https://doc.locomotivecms.com/v4.0/docs/slug
  #   https://locomotive-v3.readme.io/docs/slug
  #   https://locomotive-v3.readme.io/v1.0/docs/slug
  #   /docs/slug
  #   /v4.0/docs/slug
  def convert_internal_links(body, link_map)
    # Absolute URLs to doc.locomotivecms.com or locomotive-v3.readme.io
    body = body.gsub(/\[([^\]]*)\]\((https?:\/\/(?:doc\.locomotivecms\.com|locomotive-v3\.readme\.io)(?:\/v[\d.]+)?\/docs\/([^\s\)#]+)(#[^\s\)]*)?\s*)\)/) do
      text = $1
      slug = $3
      anchor = $4 || ''
      new_path = link_map[slug] || "/#{slug}"
      "[#{text}](#{new_path}#{anchor})"
    end

    # Relative /docs/slug links
    body = body.gsub(/\[([^\]]*)\]\(\/(?:v[\d.]+\/)?docs\/([^\s\)#]+)(#[^\s\)]*)?\)/) do
      text = $1
      slug = $2
      anchor = $3 || ''
      new_path = link_map[slug] || "/#{slug}"
      "[#{text}](#{new_path}#{anchor})"
    end

    body
  end

  # Protect Liquid-like syntax from being interpreted by the Liquid parser.
  # Two strategies:
  # 1. Wrap code blocks containing Liquid with {% raw %} / {% endraw %}
  # 2. Protect inline Liquid references in prose text (backticks, tables, etc.)
  OUR_TAGS = %w[hint endhint code endcode tabs endtabs tab endtab description enddescription raw endraw].freeze

  def protect_liquid_in_code_blocks(body)
    # First: protect fenced code blocks
    body = body.gsub(/(```[^\n]*\n)(.*?)(```)/m) do |match|
      opening = $1
      code = $2
      closing = $3

      if code.match?(/\{[%{]/) || code.match?(/%\}/) || code.match?(/\}\}/)
        "{% raw %}\n#{opening}#{code}#{closing}\n{% endraw %}"
      else
        match
      end
    end

    # Second: protect inline Liquid references in prose text
    # Process line by line, skip lines that are our Liquid tags or inside raw blocks
    lines = body.lines
    result = []
    in_raw = false
    in_code_fence = false

    lines.each do |line|
      stripped = line.strip

      # Track raw blocks
      if stripped == '{% raw %}'
        in_raw = true
        result << line
        next
      elsif stripped == '{% endraw %}'
        in_raw = false
        result << line
        next
      end

      # Track code fences
      if stripped.start_with?('```')
        in_code_fence = !in_code_fence
        result << line
        next
      end

      # Skip if we're inside raw or code blocks
      if in_raw || in_code_fence
        result << line
        next
      end

      # Skip if this line IS one of our Liquid tags
      if stripped.match?(/^\{%\s*(#{OUR_TAGS.join('|')})\b/)
        result << line
        next
      end

      # Protect any remaining {%...%} or {{...}} on this line
      if line.match?(/\{[%{]/) || line.match?(/[%}]\}/)
        # Wrap individual occurrences inline
        protected_line = line
          .gsub(/\{\{(.*?)\}\}/) { |m| "{% raw %}#{m}{% endraw %}" }
          .gsub(/\{%((?!\s*(?:#{OUR_TAGS.join('|')})\b).*?)%\}/) { |m| "{% raw %}#{m}{% endraw %}" }
        result << protected_line
      else
        result << line
      end
    end

    result.join
  end

  # Clean up various README.com artifacts
  def cleanup(body)
    body = body.gsub("&#x20;", " ")
    body = body.gsub(/\\\n/, "\n") # trailing backslash line continuations
    body = body.gsub(/\\\-/, "-")
    body = body.gsub(/\\:/, ":") # escaped colons like http\://
    body = body.gsub(/\\_/, "_") # escaped underscores in content
    body
  end
end

# ─── Page Tree Builder ──────────────────────────────────────────────────────────

class PageNode
  attr_accessor :title, :slug, :source_path, :order, :children, :parent, :is_folder

  def initialize(title:, slug:, source_path: nil, order: 0, parent: nil)
    @title = title
    @slug = slug
    @source_path = source_path
    @order = order
    @parent = parent
    @children = []
    @is_folder = false
  end

  def add_child(node)
    node.parent = self
    @children << node
    @is_folder = true
    node
  end

  def output_dir_slug
    slug.downcase.gsub(/\s+/, '-').gsub(/[^a-z0-9-]/, '')
  end

  def path_segments
    segments = []
    node = self
    while node.parent
      segments.unshift(node.output_dir_slug)
      node = node.parent
    end
    segments
  end

  def output_path(base_dir)
    File.join(base_dir, *path_segments)
  end
end

# ─── Tree Builder ───────────────────────────────────────────────────────────────

def build_tree(input_dir)
  docs_dir = File.join(input_dir, 'docs')
  raise "No docs/ directory found in #{input_dir}" unless File.directory?(docs_dir)

  root = PageNode.new(title: 'Root', slug: 'root')

  # Read top-level category order
  top_order_file = File.join(docs_dir, '_order.yaml')
  categories = if File.exist?(top_order_file)
    YAML.safe_load(File.read(top_order_file)) || []
  else
    Dir.children(docs_dir)
      .select { |f| File.directory?(File.join(docs_dir, f)) }
      .sort
  end

  categories.each_with_index do |category_name, cat_index|
    category_dir = File.join(docs_dir, category_name)
    next unless File.directory?(category_dir)

    category_node = PageNode.new(
      title: category_name,
      slug: category_name,
      order: (cat_index + 1) * 1
    )
    root.add_child(category_node)

    # Read page order within category
    cat_order_file = File.join(category_dir, '_order.yaml')
    page_slugs = if File.exist?(cat_order_file)
      YAML.safe_load(File.read(cat_order_file)) || []
    else
      Dir.children(category_dir)
        .select { |f| f.end_with?('.md') }
        .map { |f| File.basename(f, '.md') }
        .sort
    end

    page_slugs.each_with_index do |page_slug, page_index|
      page_md = File.join(category_dir, "#{page_slug}.md")
      page_dir = File.join(category_dir, page_slug)

      if File.exist?(page_md)
        # Simple page
        page_node = PageNode.new(
          title: page_slug,
          slug: page_slug,
          source_path: page_md,
          order: (page_index + 1) * 1
        )
        category_node.add_child(page_node)
      elsif File.directory?(page_dir)
        # Subfolder (e.g., Sections/setup-a-section/)
        # Check for index.md
        folder_node = PageNode.new(
          title: page_slug,
          slug: page_slug,
          order: (page_index + 1) * 1
        )

        index_md = File.join(page_dir, 'index.md')
        if File.exist?(index_md)
          folder_node.source_path = index_md
        end

        # Read sub-page order
        sub_order_file = File.join(page_dir, '_order.yaml')
        sub_slugs = if File.exist?(sub_order_file)
          YAML.safe_load(File.read(sub_order_file)) || []
        else
          Dir.children(page_dir)
            .select { |f| f.end_with?('.md') && f != 'index.md' }
            .map { |f| File.basename(f, '.md') }
            .sort
        end

        sub_slugs.each_with_index do |sub_slug, sub_index|
          sub_md = File.join(page_dir, "#{sub_slug}.md")
          if File.exist?(sub_md)
            sub_node = PageNode.new(
              title: sub_slug,
              slug: sub_slug,
              source_path: sub_md,
              order: (sub_index + 1) * 1
            )
            folder_node.add_child(sub_node)
          end
        end

        category_node.add_child(folder_node)
      end
    end
  end

  root
end

# ─── Link Map Builder ───────────────────────────────────────────────────────────

def build_link_map(root)
  map = {}
  visit_for_links(root, map)
  map
end

def visit_for_links(node, map)
  if node.source_path && node.parent
    # Map the original slug to the new path
    original_slug = File.basename(node.source_path, '.md')
    original_slug = node.slug if original_slug == 'index'

    segments = node.path_segments
    new_path = "/" + segments.join("/")

    map[original_slug] = new_path

    # Also map with hyphenated slug (some links use this format)
    map[node.slug] = new_path
  end

  node.children.each { |child| visit_for_links(child, map) }
end

# ─── Frontmatter Processor ─────────────────────────────────────────────────────

def process_frontmatter(source_path, order)
  content = File.read(source_path)

  # Extract frontmatter
  if content =~ /\A---\n(.*?)\n---\n(.*)/m
    frontmatter = YAML.safe_load($1) || {}
    body = $2
  else
    frontmatter = {}
    body = content
  end

  title = frontmatter['title'] || extract_title(body) || File.basename(source_path, '.md').gsub('-', ' ').capitalize
  excerpt = frontmatter['excerpt']

  new_frontmatter = {
    'title' => title,
    'order' => order
  }

  # Insert description block if excerpt is present and non-empty
  if excerpt && !excerpt.strip.empty?
    # Find the H1 and insert description after it
    if body =~ /^# .+$/
      body = body.sub(/^(# .+)$/) do
        "#{$1}\n{% description %}\n#{excerpt.strip}\n{% enddescription %}\n"
      end
    else
      body = "{% description %}\n#{excerpt.strip}\n{% enddescription %}\n\n#{body}"
    end
  end

  [new_frontmatter, body]
end

def extract_title(content)
  content.each_line do |line|
    if line.strip.start_with?('# ')
      return line.strip.sub(/^# /, '').strip
    end
  end
  nil
end

# ─── File Writer ────────────────────────────────────────────────────────────────

class PageExporter
  attr_reader :output_dir, :link_map, :download_images, :dry_run, :stats

  def initialize(output_dir:, link_map:, download_images: false, dry_run: false)
    @output_dir = output_dir
    @link_map = link_map
    @download_images = download_images
    @dry_run = dry_run
    @stats = { pages: 0, images: 0, folders: 0, errors: [] }
  end

  def export(root)
    root.children.each { |child| visit(child) }
    download_all_images if download_images
    print_stats
  end

  private

  def visit(node)
    if node.children.any?
      export_folder(node)
      node.children.each { |child| visit(child) }
    elsif node.source_path
      export_page(node)
    end
  end

  def export_folder(node)
    dir_path = node.output_path(output_dir)

    if node.source_path
      # Folder has its own content → write it as index.html.md inside the folder
      export_page_as_index(node)
    else
      # No content → create a redirect index
      index_path = File.join(dir_path, 'index.html.erb')
      first_child = node.children.first

      if first_child
        segments = first_child.path_segments
        if first_child.children.any? && first_child.children.first
          segments = first_child.children.first.path_segments
        end
        first_child_path = "/" + segments.join("/")

        content = <<~ERB
          ---
          title: #{node.title}
          redirect_to: #{first_child_path}
          order: #{node.order}
          ---
        ERB

        write_file(index_path, content)
      end
    end

    @stats[:folders] += 1
  end

  def export_page_as_index(node)
    return unless node.source_path

    page_slug = node.output_dir_slug
    frontmatter, body = process_frontmatter(node.source_path, node.order)

    $images_to_download = []
    body = Transformations.convert_html_blocks(body)
    body = Transformations.convert_html_tables(body)
    body = Transformations.convert_image_components(body, page_slug)
    body = Transformations.convert_markdown_images(body, page_slug)
    body = Transformations.convert_callouts(body)
    body = Transformations.convert_code_blocks(body)
    body = Transformations.convert_internal_links(body, link_map)
    body = Transformations.cleanup(body)
    body = Transformations.protect_liquid_in_code_blocks(body)

    dir_path = node.output_path(output_dir)
    FileUtils.mkdir_p(dir_path) unless dry_run
    file_path = File.join(dir_path, "index.html.md")

    content = "#{frontmatter.to_yaml.strip}\n---\n\n#{body.strip}\n"

    write_file(file_path, content)
    @stats[:pages] += 1

    @all_images ||= []
    @all_images.concat($images_to_download || [])
    @stats[:images] += ($images_to_download || []).length
  end

  def export_page(node, is_index: false)
    return unless node.source_path

    page_slug = node.output_dir_slug
    frontmatter, body = process_frontmatter(node.source_path, node.order)

    # Apply all transformations
    $images_to_download = []
    body = Transformations.convert_html_blocks(body)
    body = Transformations.convert_html_tables(body)
    body = Transformations.convert_image_components(body, page_slug)
    body = Transformations.convert_markdown_images(body, page_slug)
    body = Transformations.convert_callouts(body)
    body = Transformations.convert_code_blocks(body)
    body = Transformations.convert_internal_links(body, link_map)
    body = Transformations.cleanup(body)
    body = Transformations.protect_liquid_in_code_blocks(body)

    # Build output path using parent's path segments
    parent_segments = node.parent ? node.parent.path_segments : []
    file_dir = File.join(output_dir, *parent_segments)
    FileUtils.mkdir_p(file_dir) unless dry_run

    file_path = File.join(file_dir, "#{page_slug}.html.md")

    content = "#{frontmatter.to_yaml.strip}\n---\n\n#{body.strip}\n"

    write_file(file_path, content)
    @stats[:pages] += 1

    # Track images for this page
    @all_images ||= []
    @all_images.concat($images_to_download || [])
    @stats[:images] += ($images_to_download || []).length
  end

  def download_all_images
    return unless @all_images&.any?

    puts "\n📥 Downloading #{@all_images.length} images..."
    @all_images.each do |img|
      image_path = File.join(IMG_OUTPUT_DIR, img[:local_path])
      FileUtils.mkdir_p(File.dirname(image_path)) unless dry_run

      if dry_run
        puts "  [DRY RUN] Would download: #{img[:url]}"
        puts "            → #{image_path}"
      else
        begin
          print "  Downloading #{File.basename(image_path)}..."
          image_data = URI.open(img[:url]).read
          File.binwrite(image_path, image_data)
          puts " ✓"
        rescue => e
          puts " ✗ (#{e.message})"
          @stats[:errors] << "Image download failed: #{img[:url]} - #{e.message}"
        end
      end
    end
  end

  def write_file(path, content)
    if dry_run
      puts "[DRY RUN] Would write: #{path} (#{content.length} bytes)"
    else
      FileUtils.mkdir_p(File.dirname(path))
      File.write(path, content)
      puts "  ✓ #{path}"
    end
  end

  def print_stats
    puts "\n" + "─" * 60
    puts "Migration Summary"
    puts "─" * 60
    puts "  Pages exported:  #{@stats[:pages]}"
    puts "  Folders created: #{@stats[:folders]}"
    puts "  Images found:    #{@stats[:images]}"
    if @stats[:errors].any?
      puts "\n  ⚠ Errors (#{@stats[:errors].length}):"
      @stats[:errors].each { |e| puts "    - #{e}" }
    end
    puts "─" * 60
  end
end

# ─── CLI ────────────────────────────────────────────────────────────────────────

options = { download_images: false, dry_run: false }
OptionParser.new do |opts|
  opts.banner = "Usage: migrate_readme.rb [options]"
  opts.on("-i", "--input DIR", "Input directory (README.com export with docs/ subfolder)") { |dir| options[:input] = dir }
  opts.on("-o", "--output DIR", "Output directory for Sitepress pages") { |dir| options[:output] = dir }
  opts.on("-d", "--download", "Download remote images to assets/images/") { options[:download_images] = true }
  opts.on("--dry-run", "Show what would be done without writing files") { options[:dry_run] = true }
  opts.on("-h", "--help", "Show this help message") { puts opts; exit }
end.parse!

unless options[:input] && options[:output]
  puts "Error: Both --input and --output are required."
  puts "Usage: ruby scripts/migrate_readme.rb -i readme-exports/locomotive-v3-v4.0 -o pages"
  exit 1
end

unless File.directory?(options[:input])
  puts "Error: Input directory '#{options[:input]}' does not exist."
  exit 1
end

puts "🚂 LocomotiveCMS README.com → Sitepress Migration"
puts "─" * 60
puts "  Input:  #{options[:input]}"
puts "  Output: #{options[:output]}"
puts "  Mode:   #{options[:dry_run] ? 'DRY RUN' : 'LIVE'}"
puts "  Images: #{options[:download_images] ? 'will download' : 'paths only (use -d to download)'}"
puts "─" * 60
puts ""

# Build page tree
puts "📂 Building page tree..."
root = build_tree(options[:input])

# Build link map for internal link rewriting
link_map = build_link_map(root)
puts "🔗 Built link map with #{link_map.length} entries"
puts ""

# Export pages
puts "📝 Exporting pages..."
exporter = PageExporter.new(
  output_dir: options[:output],
  link_map: link_map,
  download_images: options[:download_images],
  dry_run: options[:dry_run]
)
exporter.export(root)
