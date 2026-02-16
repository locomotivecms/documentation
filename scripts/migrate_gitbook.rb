#!/usr/bin/env ruby

# Gitbook to Sitepress Markdown Migration Script
# Rewrites Gitbook markdown files for Sitepress, using custom Liquid tags and folder structure

require 'fileutils'
require 'optparse'
require 'yaml'
require 'open-uri'
require 'nokogiri'
require 'json'
require 'cgi'
require 'active_support/core_ext/string/inflections'
require 'byebug'

IMG_PREFIX = 'pages'
IMG_DIR = './assets/images'

class MarkdownExtractor
  attr_accessor :base_url

  def initialize(base_url)
    @base_url = base_url
  end

  def call(path)
    content = URI.open(URI.join(base_url, path)).read
    attributes, body = extract_frontmatter_and_body(content)
    basename = File.basename(path, '.md')

    attributes['title'] ||= extract_title(body) || basename

    if description = attributes.delete('description')
      body = insert_description_block(body, description)
    end

    body = body.gsub("\\-", "-").gsub("&#x20;", " ")

    images = extract_images(body, basename)

    [attributes, body, images]
  end

  private

  def extract_frontmatter_and_body(content)
    if content =~ /^---\n(.*?)\n---\n(.*)/m
      frontmatter = YAML.safe_load($1) || {}
      body = $2
      [frontmatter, body]
    else
      [{}, content]
    end
  end

  def extract_title(content)
    content.each_line do |line|
      if line.strip.start_with?('# ')
        return line.strip.sub(/^# /, '').strip
      end
    end
  end

  def insert_description_block(body, description)
    lines = body.lines
    h1_idx = lines.find_index { |l| l.strip.start_with?('# ') }
    return body unless h1_idx
    desc_block = ["{% description %}", description.strip, '{% enddescription %}', '']
    lines.insert(h1_idx + 1, *desc_block.map { |l| l + "\n" })
    lines.join
  end

  def extract_images(body, basename)
    body.scan(/!\[.*?\]\(.*?\)/).each_with_index.map do |match, index|
      image_url = match.match(/!\[.*?\]\((.*?)\)/)[1]
      locale_image_url = "#{IMG_PREFIX}/#{basename}-#{index + 1}#{File.extname(image_url).split('?').first}"
      body.gsub!(image_url, locale_image_url)
      [locale_image_url, image_url]
    end
  end
end

class DebugPageVisitor
  def visit(node)
    puts "#{"." * node.depth}Visiting '#{node.href || 'root'}' (##{node.order})"
    if node.folder?
      node.children.each { |child| visit(child) }
    end
  end
end

class ExportPageVisitor
  attr_accessor :extractor, :output_dir, :img_output_dir

  def initialize(base_url, output_dir, img_output_dir)
    @extractor = MarkdownExtractor.new(base_url)
    @output_dir = output_dir
    @img_output_dir = img_output_dir

    FileUtils.mkdir_p(output_dir)
    FileUtils.mkdir_p(img_output_dir)
  end

  def visit(node)
    if node.folder?
      write_folder_index(node) unless node.parent.nil?
      node.children.each { |child| visit(child) }
    else
      write_page(node)
    end
  end

  private

  def write_page(node)
    page_path = File.join(output_dir, node.markdown_path)
    attributes, body, images = extractor.call(node.server_markdown_path)
    attributes['order'] = node.order
    content = "#{attributes.to_yaml.strip}\n---\n\n#{body.strip}\n"
    File.write(page_path, content)
    puts "Created: #{page_path} -> #{node.href}"
    write_images(images)
  end

  def write_folder_index(node)
    index_path = File.join(output_dir, node.dirname, 'index.html.erb')
    FileUtils.mkdir_p(File.dirname(index_path))
    content = <<~YAML
      ---
      title: #{node.humanized_dirname}
      redirect_to: #{node.first_child_href}
      order: #{node.order}
      ---
    YAML
    File.write(index_path, content)
    puts "Created: #{index_path} -> #{node.first_child_href}"
  end

  # def write_images(images)
  #   images.each do |locale_image_url, image_url|
  #     image_path = File.join(img_output_dir, locale_image_url)
  #     pp image_url
  #     image_content = URI.open(image_url).read
  #     raise 'tODO'
  #     File.write(image_path, image_content)
  #     puts "\tDownloaded: #{image_url} -> #{image_path}"
  #   end
  # end
  def write_images(images)
    images.each do |locale_image_url, image_url|
      image_path = File.join(img_output_dir, locale_image_url)
      image_content = nil

      URI.open(image_url) do |f|
        if f.content_type.start_with?('image/')
          image_content = f.read
        elsif f.content_type == 'application/json'
          json = JSON.parse(f.read)
          if json['bucket'] && json['name'] && json['downloadTokens']
            encoded_name = CGI.escape(json['name'])
            direct_url = "https://firebasestorage.googleapis.com/v0/b/#{json['bucket']}/o/#{encoded_name}?alt=media&token=#{json['downloadTokens']}"
            image_content = URI.open(direct_url).read
          else
            raise "Unexpected JSON structure for image: #{image_url}"
          end
        else
          raise "Unknown content type: #{f.content_type} for #{image_url}"
        end
      end

      File.write(image_path, image_content)
      puts "\tDownloaded: #{image_url} -> #{image_path}"
    end
  end
end

class PageNode
  attr_accessor :href, :parent, :order, :children

  def initialize(href: nil, parent: nil, order: 0)
    @href = href
    @parent = parent
    @order = order
    @children = []
  end

  def folder?
    @children.any?
  end

  def humanized_dirname
    dirname.split('/').last.humanize
  end

  def dirname
    href.nil? ? File.dirname(first_child_href) : href
  end

  def first_child_href
    children.first&.href
  end

  def depth
    @parent ? @parent.depth + 1 : 0
  end

  def server_markdown_path
    "#{href == '/' ? 'master' : href}.md"
  end

  def markdown_path
    "#{href == '/' ? 'index' : href}.html.md"
  end

  def append_child(href:)
    child = self.class.new(href: href, parent: self, order: children.size + 1)
    @children << child
    child
  end
end

def build_tree(links)
  root_node = PageNode.new
  current_node = root_node
  current_folder = '/'

  links.each do |link|
    folder = File.dirname(link['href'])

    if folder == current_folder
      current_node.append_child(href: link['href'])
    else
      # we only support 2 levels of folders for now
      source_node = folder.start_with?(current_folder) ? current_node : root_node
      current_node = source_node.append_child(href: nil)
      current_node.append_child(href: link['href'])
      current_folder = folder
    end
  end

  root_node
end

def crawl_and_build_tree(root_url)
  puts "Crawling index page: #{root_url}"
  # Get the HTML content of the index page
  html = URI.open(root_url).read
  # Parse the HTML content with Nokogiri
  doc = Nokogiri::HTML(html)
  # Find all the links in the sidebar
  sidebar_links = doc.css('aside ul a')
  build_tree(sidebar_links)
end

# CLI
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: migrate_gitbook.rb [options]"
  opts.on("-i", "--input URL", "Input URL to crawl and download all .md files") { |url| options[:input] = url }
  opts.on("-o", "--output DIR", "Output directory for Sitepress markdown files") { |dir| options[:output] = dir }
  opts.on("-h", "--help", "Show this help message") { puts opts; exit }
end.parse!

if options[:input] && options[:output]
  root = crawl_and_build_tree(options[:input])
  # DebugPageVisitor.new.visit(root)
  ExportPageVisitor.new(options[:input], options[:output], IMG_DIR).visit(root)
else
  puts "Usage: ruby scripts/migrate_gitbook.rb -i https://docs.maglev.dev/ -o ./pages"
end
