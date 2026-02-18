#!/usr/bin/env ruby

# Script to extract sidebar navigation structure from README.com documentation
# Usage: ruby scripts/extract_readme_navigation.rb

require 'open-uri'
require 'nokogiri'
require 'json'
require 'uri'
require 'ostruct'

class NavigationExtractor
  def initialize(base_url)
    @base_url = base_url
    @version = extract_version(base_url)
  end

  def extract_version(url)
    if url.match(%r{/v(\d+\.\d+)/})
      $1
    elsif url.match(%r{/docs$})
      'latest'
    else
      'unknown'
    end
  end

  def extract_navigation
    puts "\n" + "="*80
    puts "Extracting navigation from: #{@base_url}"
    puts "Version: #{@version}"
    puts "="*80

    begin
      html = URI.open(@base_url, 'User-Agent' => 'Mozilla/5.0').read
      doc = Nokogiri::HTML(html)
      
      # Try multiple selectors for README.com sidebar navigation
      sidebar_selectors = [
        'aside nav a',
        'aside ul a',
        'nav[aria-label*="sidebar"] a',
        '[data-sidebar] a',
        '.sidebar a',
        'aside a'
      ]

      links = []
      sidebar_selectors.each do |selector|
        found_links = doc.css(selector)
        if found_links.any?
          puts "\nFound #{found_links.length} links using selector: #{selector}"
          links = found_links
          break
        end
      end

      if links.empty?
        puts "\n⚠️  No sidebar links found. Trying alternative methods..."
        
        # Try to find version selector (which often contains page links)
        version_info = extract_version_info(doc)
        puts "\nVersion selector info: #{version_info.length} items found" if version_info
        
        # Try to find any nav structure
        all_nav_links = doc.css('nav a, [role="navigation"] a')
        puts "Found #{all_nav_links.length} navigation links total"
        
        # Try to extract navigation from version selector links
        nav_from_version_selector = []
        if version_info
          version_info.each do |version_link|
            # For v3.3, these are actually page links, not version links
            if version_link && version_link.include?('/docs/')
              # Extract a better title from the path
              path_parts = version_link.split('/').reject(&:empty?)
              title = path_parts.last.gsub('-', ' ').split.map(&:capitalize).join(' ')
              
              nav_from_version_selector << {
                title: title,
                href: version_link.start_with?('http') ? version_link : URI.join(@base_url, version_link).to_s,
                path: version_link
              }
            end
          end
        end
        
        # Try to find JSON data that might contain navigation
        json_data = extract_json_navigation(doc)
        
        # If we found navigation from version selector, use that
        if nav_from_version_selector.any?
          # Create simple link objects
          links = nav_from_version_selector.map do |item|
            link_obj = Object.new
            def link_obj.text; @text; end
            def link_obj.text=(val); @text = val; end
            def link_obj.[](key); @attrs ||= {}; @attrs[key]; end
            def link_obj.[]=(key, val); @attrs ||= {}; @attrs[key] = val; end
            link_obj.text = item[:title]
            link_obj['href'] = item[:href]
            link_obj
          end
        end
        
        # If still no links, return what we found
        if links.empty?
          return {
            version: @version,
            url: @base_url,
            sidebar_links: nav_from_version_selector,
            page_count: nav_from_version_selector.length,
            versions_available: version_info,
            json_navigation: json_data,
            structure: "No sidebar navigation found - may require JavaScript rendering"
          }
        end
      end

      # Extract link information
      navigation_items = []
      links.each do |link|
        href = link['href']
        text = link.text.strip
        next if text.empty? || href.nil?
        
        # Make href absolute if relative
        href = URI.join(@base_url, href).to_s unless href.start_with?('http')
        
        path = begin
          URI.parse(href).path
        rescue
          href
        end
        navigation_items << {
          title: text,
          href: href,
          path: path
        }
      end

      # Try to detect hierarchy (check parent elements)
      hierarchy = detect_hierarchy(doc, links)
      
      # Extract version selector if present
      version_info = extract_version_info(doc)

      {
        version: @version,
        url: @base_url,
        sidebar_links: navigation_items,
        hierarchy: hierarchy,
        page_count: navigation_items.length,
        versions_available: version_info,
        structure: build_structure_text(hierarchy || navigation_items)
      }
    rescue => e
      {
        version: @version,
        url: @base_url,
        error: e.message,
        sidebar_links: [],
        page_count: 0
      }
    end
  end

  def detect_hierarchy(doc, links)
    hierarchy = []
    current_category = nil
    
    links.each do |link|
      # Check if this link is in a category/group
      parent_li = link.ancestors('li').first
      if parent_li
        # Check for category headers (usually a div or span before the link)
        category_elem = parent_li.css('> div, > span').first
        if category_elem && category_elem.text.strip.length > 0 && !category_elem.css('a').any?
          category_name = category_elem.text.strip
          if category_name != current_category
            hierarchy << { type: 'category', name: category_name, children: [] }
            current_category = category_name
          end
        end
        
        # Add link to current category or as top-level
        path = begin
          URI.parse(link['href']).path
        rescue
          link['href']
        end
        link_info = {
          title: link.text.strip,
          href: link['href'],
          path: path
        }
        
        if current_category && hierarchy.last
          hierarchy.last[:children] << link_info
        else
          hierarchy << link_info
        end
      else
        path = begin
          URI.parse(link['href']).path
        rescue
          link['href']
        end
        hierarchy << {
          title: link.text.strip,
          href: link['href'],
          path: path
        }
      end
    end
    
    hierarchy
  end

  def extract_version_info(doc)
    # Look for version selector dropdowns or links
    version_selectors = [
      'select[name*="version"]',
      '[data-version-selector]',
      '.version-selector',
      'nav a[href*="/v"]',
      'nav a[href*="/docs"]'
    ]
    
    versions = []
    version_selectors.each do |selector|
      elements = doc.css(selector)
      if elements.any?
        elements.each do |elem|
          if elem.name == 'select'
            elem.css('option').each { |opt| versions << opt['value'] if opt['value'] }
          elsif elem['href']
            href = elem['href']
            # Make absolute if relative
            href = URI.join(@base_url, href).to_s unless href.start_with?('http')
            versions << href
          end
        end
        break if versions.any?
      end
    end
    
    versions.any? ? versions.uniq : nil
  end

  def extract_json_navigation(doc)
    # Look for JSON-LD or script tags with navigation data
    json_data = []
    
    # Check for script tags with JSON data
    doc.css('script[type="application/json"], script[type="application/ld+json"]').each do |script|
      begin
        data = JSON.parse(script.text)
        json_data << data if data.is_a?(Hash) || data.is_a?(Array)
      rescue JSON::ParserError
        # Not valid JSON, skip
      end
    end
    
    # Check for data attributes that might contain navigation
    doc.css('[data-navigation], [data-pages]').each do |elem|
      begin
        nav_data = JSON.parse(elem['data-navigation'] || elem['data-pages'] || '{}')
        json_data << nav_data if nav_data.any?
      rescue JSON::ParserError
        # Not valid JSON, skip
      end
    end
    
    json_data.any? ? json_data : nil
  end

  def build_structure_text(structure)
    return "No structure detected" unless structure.is_a?(Array)
    
    text = ""
    structure.each do |item|
      if item[:type] == 'category'
        text += "\n  #{item[:name]}:\n"
        item[:children].each do |child|
          text += "    - #{child[:title]} (#{child[:path]})\n"
        end
      else
        text += "  - #{item[:title]} (#{item[:path]})\n"
      end
    end
    text
  end
end

# URLs to extract
urls = [
  'https://doc.locomotivecms.com/docs',
  'https://doc.locomotivecms.com/v4.0/docs',
  'https://doc.locomotivecms.com/v3.3/docs',
  'https://doc.locomotivecms.com/docs/content-types',
  'https://doc.locomotivecms.com/docs/templates',
  'https://doc.locomotivecms.com/docs/section-introduction',
  'https://doc.locomotivecms.com/docs/how-to-display-sections',
  'https://doc.locomotivecms.com/docs/events',
  'https://doc.locomotivecms.com/docs/deploy',
  'https://doc.locomotivecms.com/docs/liquid-syntax',
  'https://doc.locomotivecms.com/docs/liquid-tags'
]

puts "\n" + "="*80
puts "LocomotiveCMS Documentation Navigation Structure Extraction"
puts "="*80

results = []
urls.each do |url|
  extractor = NavigationExtractor.new(url)
  result = extractor.extract_navigation
  results << result
  
  # Print summary
  puts "\n📊 Summary:"
  puts "  Version: #{result[:version]}"
  puts "  Pages found: #{result[:page_count]}"
  puts "  Versions available: #{result[:versions_available] || 'Not detected'}"
  if result[:error]
    puts "  ❌ Error: #{result[:error]}"
  end
  puts "\n" + "-"*80
end

# Generate comprehensive report
puts "\n\n" + "="*80
puts "COMPREHENSIVE NAVIGATION INVENTORY"
puts "="*80

results.each do |result|
  next if result[:error]
  
  puts "\n#{result[:version].upcase} VERSION (#{result[:url]})"
  puts "-" * 80
  puts "Total pages: #{result[:page_count]}"
  puts "Versions available: #{result[:versions_available] || 'Not detected'}"
  
  if result[:hierarchy] && result[:hierarchy].any?
    puts "\nNavigation Structure:"
    result[:hierarchy].each do |item|
      if item[:type] == 'category'
        puts "\n  📁 #{item[:name]}"
        item[:children].each do |child|
          puts "     └─ #{child[:title]}"
        end
      else
        puts "  • #{item[:title]}"
      end
    end
  elsif result[:sidebar_links] && result[:sidebar_links].any?
    puts "\nNavigation Links:"
    result[:sidebar_links].each do |link|
      puts "  • #{link[:title]} (#{link[:path]})"
    end
  else
    puts "\n⚠️  No navigation structure found"
  end
end

# Save to JSON file
File.write('navigation_structure.json', JSON.pretty_generate(results))
puts "\n\n✅ Results saved to navigation_structure.json"
