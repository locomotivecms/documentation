#!/usr/bin/env ruby

require 'json'
require 'redcarpet'

PAGES_DIR = 'pages'
OUTPUT_FILE = 'assets/javascripts/search-index.json'

# Initialize Redcarpet markdown renderer
$markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)

# Remove Liquid tags and their inner content from markdown
# Handles block tags (e.g., {% tabs %}...{% endtabs %}) and inline tags ({% ... %}, {{ ... }})
def remove_liquid_tags(markdown)
  markdown = markdown.gsub(/\{\%\s*(\w+)\s*\%\}.*?\{\%\s*end\1\s*\%\}/m, '')
  markdown = markdown.gsub(/\{\%.*?\%\}/m, '')
  markdown = markdown.gsub(/\{\{.*?\}\}/m, '')
  markdown
end

# Remove Markdown image tags (![alt](url)) from markdown
def remove_markdown_images(markdown)
  markdown.gsub(/!\[.*?\]\(.*?\)/, '')
end

# Remove frontmatter block (YAML between --- at the top) from markdown
def remove_frontmatter(markdown)
  markdown.sub(/\A---\s*\n.*?\n---\s*\n/m, '')
end

# Extracts title, h2, h3 from markdown text
def extract_markdown_content(file_path)
  lines = File.readlines(file_path)
  title = nil
  headings = []
  lines.each do |line|
    if line.start_with?('# ')
      title ||= line.sub(/^# /, '').strip
    elsif line.start_with?('## ')
      headings << line.sub(/^## /, '').strip
    elsif line.start_with?('### ')
      headings << line.sub(/^### /, '').strip
    end
  end
  title ||= File.basename(file_path, '.*').capitalize
  markdown_content = lines.join
  markdown_content = remove_frontmatter(markdown_content)
  markdown_content = remove_liquid_tags(markdown_content)
  markdown_content = remove_markdown_images(markdown_content)
  html_content = $markdown.render(markdown_content)
  {
    id: File.basename(file_path, '.*'),
    title: title,
    headings: headings,
    content: html_content,
    url: file_path.sub(/^#{PAGES_DIR}\//, '/').sub(/\.html\.md$/, '')
  }
end

def collect_pages
  Dir.glob("#{PAGES_DIR}/**/*.md").map do |file|
    extract_markdown_content(file)
  end
end

index = collect_pages
File.write(OUTPUT_FILE, JSON.pretty_generate(index))
puts "Generated #{OUTPUT_FILE} with #{index.size} entries."
