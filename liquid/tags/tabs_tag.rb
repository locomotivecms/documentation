class Liquid::Tags::TabsTag < Liquid::Block
  include Liquid::Tags::Concerns::MarkdownConcern

  def render(context)
    tabs_index = context.registers[:tabs_html].size
    context.registers[:tabs_html] << context.stack do
      context['tabs'] = []
      content = super(context)
      render_tabs(context['tabs'], content)
    end

    # This is a hack to get the tabs HTML into the final document without messing up with the Markdown renderer.
    "<!-- tabs##{tabs_index} -->"
  end

  private

  def render_tabs(tabs, content)
    <<~HTML
    <div
      data-controller="tabs"
      data-tabs-link-class-value="text-gray-500 hover:text-gray-700" data-tabs-active-link-class-value="bg-gray-100 text-gray-700"
    >
      <div class="grid grid-cols-1 sm:hidden">
        #{render_select_nav(tabs)}
        <svg viewBox="0 0 16 16" fill="currentColor" data-slot="icon" aria-hidden="true" class="pointer-events-none col-start-1 row-start-1 mr-2 size-5 self-center justify-self-end fill-gray-500">
          <path d="M4.22 6.22a.75.75 0 0 1 1.06 0L8 8.94l2.72-2.72a.75.75 0 1 1 1.06 1.06l-3.25 3.25a.75.75 0 0 1-1.06 0L4.22 7.28a.75.75 0 0 1 0-1.06Z" clip-rule="evenodd" fill-rule="evenodd" />
        </svg>
      </div>
      <div class="hidden sm:block">
        #{render_link_nav(tabs)}
      </div>
      <div class="mt-6">
        #{content}
      </div>
    </div>
    HTML
  end

  def render_select_nav(tabs)
    options = tabs.each_with_index.map do |tab, index|
      <<~HTML
      <option #{index == 0 ? 'selected' : ''} value="#{index}">#{tab}</option>
      HTML
    end.join

    <<~HTML
    <select
      aria-label="Select a tab"
      data-tabs-target="select"
      class="col-start-1 row-start-1 w-full appearance-none rounded-md bg-white py-2 pr-8 pl-3 text-base text-gray-900 outline-1 -outline-offset-1 outline-gray-300 focus:outline-2 focus:-outline-offset-2 focus:outline-zinc-600 dark:bg-zinc-800 dark:text-zinc-100 dark:outline-zinc-700"
      data-action="change->tabs#select">#{options}</select>
    HTML
  end

  def render_link_nav(tabs)
    links = tabs.each_with_index.map do |tab, index|
      <<~HTML
      <a
        href="#"
        data-action="click->tabs#select"
        data-tabs-target="link"
        data-tab-index="#{index}"
        class="not-prose rounded-md px-3 py-2 text-sm font-medium #{index == 0 ? 'bg-gray-100 text-gray-700' : 'text-gray-500 hover:text-gray-700'}">#{tab}</a>
      HTML
    end.join

    <<~HTML
    <nav aria-label="Tabs" class="flex space-x-4">
      #{links}
    </nav>
    HTML
  end
end
