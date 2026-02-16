class Liquid::Tags::TabTag < Liquid::Block
  include Liquid::Tags::Concerns::MarkdownConcern

  attr_reader :title

  # {% tab title="Template" %}
  def initialize(tag_name, markup, tokens)
    super
    @title = markup.scan(/title="([^"]+)"/).flatten.first
  end

  def render(context)
    is_first = context['tabs'].empty?
    index = context['tabs'].size
    context['tabs'] << title

    <<~HTML
    <div
      class="#{is_first ? 'block' : 'hidden'}"
      data-tabs-target="pane"
      data-tab-pane-index="#{index}"
    >
      #{render_markdown(super(context), context)}
    </div>
    HTML
  end
end
