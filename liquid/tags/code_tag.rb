class Liquid::Tags::CodeTag < Liquid::Block
  include Liquid::Tags::Concerns::MarkdownConcern

  attr_reader :title

  # Example:
  # {% code title="Gemfile" %}
  # ```ruby
  # gem 'maglevcms', '~> 2.0.0'
  # gem 'maglevcms-hyperui-kit', '~> 1.2.0'
  # ```
  # {% endcode %}
  def initialize(tag_name, markup, tokens)
    super
    @title =CGI.unescapeHTML(markup).scan(/title="([^"]*)"/).flatten.first
  end

  def render(context)
    append_title(
      render_markdown(super, context)
    )
  rescue => e
    puts e
    raise e
  end

  private

  def append_title(content)
    return content if title.blank?

    content.gsub("<code",
      <<~HTML
      <p class="not-prose text-sm mb-2 font-medium text-gray-500 dark:text-gray-400">#{title}</p><code class="block overflow-x-auto w-full"
      HTML
      .strip
    )
  end

end
