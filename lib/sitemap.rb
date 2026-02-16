require 'sitepress-core'
require 'erb'

class Sitemap

  attr_reader :site, :base_url, :path

  def initialize(path:, base_url:)
    @path = path
    @site = Sitepress::Site.new(root_path: path)
    @base_url = base_url
  end

  def self.compile(path:, base_url:)
    new(path:, base_url:).compile
  end

  def compile
    erb = ERB.new(File.open(template_path).read)
    File.open(sitemap_path, 'w+') do |file|
      file.write(erb.result(binding))
    end
  end

  def pages
    site.resources
    .glob('*.html.*')
    .sort_by { |r| r.data.fetch("order", Float::INFINITY) }
    .map do |resource|
      Page.new(
        File.join(base_url, resource.request_path),
        File.mtime(resource.asset.path).strftime('%F'),
        case resource.request_path
        when '/' then 1
        when '/404' then 0.5
        else 0.8
        end
      )
    end
  end

  private

  def template_path
    File.join(path, 'lib', 'sitemap.xml.erb')
  end

  def sitemap_path
    File.join(path, 'build', 'sitemap.xml')
  end

  class Page < Struct.new(:url, :lastmod, :priority); end
end
