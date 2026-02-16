class Liquid::Tags::DescriptionTag < Liquid::Block
  def initialize(tag_name, text, tokens)
    super
  end

  def render(context)
    <<~HTML
    <p class="not-prose text-zinc-500 dark:text-zinc-400 -translate-y-6">
      #{super}
    </p>
    HTML
    .strip
  end
end
