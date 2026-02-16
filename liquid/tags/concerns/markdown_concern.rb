module Liquid::Tags::Concerns
  module MarkdownConcern
    def render_markdown(content, context)
      markdown_renderer = context.registers[:markdown_renderer]
      markdown_renderer.render(content.strip)
    end
  end
end
