module LiquidHelpers
  class TestMarkdownRenderer < MarkdownRails::Renderer::Base
    include Redcarpet::Render::SmartyPants
    include MarkdownRails::Helper::Rouge

    def enable
      []
    end
  end

  def render_liquid_tag(tag_name, content, markup = '', registers = {})
    Liquid::Environment.default.error_mode = :strict
    template = Liquid::Template.parse("{% #{tag_name} #{markup} %}#{content}{% end#{tag_name} %}")
    # puts "{% #{tag_name} #{markup} %}\n#{content}{% end#{tag_name} %}"
    template.render({}, registers: {
      markdown_renderer: TestMarkdownRenderer.new.renderer,
  }.merge(registers), rethrow_errors: true)
  end

  def register_liquid_tag(tag_name, tag_class)
    Liquid::Template.register_tag(tag_name, tag_class)
  end
end

RSpec.configure do |config|
  config.include LiquidHelpers
end
