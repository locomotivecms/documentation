class Liquid::Tags::HintTag < Liquid::Block
  include Liquid::Tags::Concerns::MarkdownConcern

  attr_reader :style

  # markup: style="info" or style=&quot;info&quot;
  def initialize(tag_name, markup, tokens)
    super
    @style = CGI.unescapeHTML(markup).scan(/style="([^"]+)"/).flatten.first
  end

  def render(context)
    html = <<~HTML
    <div class="border-l-4 p-4 #{wrapper_css_class}">
      <div class="flex">
        <div class="shrink-0 -translate-y-0.5">#{icon_html}</div>
        <div class="ml-3 text-sm #{text_css_class} dark:text-white prose-p:my-0">#{render_markdown(clean_content(super), context)}</div>
      </div>
    </div>
    HTML

    # Remove whitespace between tags
    html.gsub(/>\s+</, '><').strip
  end

  private

  def wrapper_css_class
    case style
    when 'info'
      'border-yellow-400 bg-yellow-50 dark:bg-transparent'
    when 'warning'
      'border-red-400 bg-red-50 dark:bg-transparent'
    when 'success'
      'border-green-400 bg-green-50 dark:bg-transparent'
    end
  end

  def icon_html
    case style
    when 'info'
      '<i class="fa-solid fa-info-circle text-yellow-400"></i>'
    when 'warning'
      '<i class="fa-solid fa-exclamation-triangle text-red-400"></i>'
    when 'success'
      '<i class="fa-solid fa-check-circle text-green-400"></i>'
    end
  end

  def text_css_class
    "text-zinc-900 dark:text-white"
  end

  def clean_content(content)
    content.gsub("\\\n", "<br/>")
  end
end
