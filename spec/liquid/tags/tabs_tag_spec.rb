require_relative '../../spec_helper'

RSpec.describe Liquid::Tags::TabsTag do
  before do
    register_liquid_tag('tabs', described_class)
    register_liquid_tag('tab', Liquid::Tags::TabTag)
    register_liquid_tag('code', Liquid::Tags::CodeTag)
  end

  let(:content) do
    <<~LIQUID
      {% tab title="Tab #1" %}
        Tab #1 content
      {% endtab %}

      {% tab title="Tab #2" %}
        Tab #2 content
      {% endtab %}

      {% tab title="Tab #3" %}
        {% code title="app/views/theme/sections/sample.html.erb" %}
        ```markup
        <%= maglev_block.setting_tag :title, html_tag: :h2 %>
        ```
        {% endcode %}
      {% endtab %}
    LIQUID
  end

  let(:tabs_html) { [] }
  let(:subject) { render_liquid_tag('tabs', content, '', { tabs_html: tabs_html }) }

  it 'renders code' do
    puts subject
    is_expected.to include('<!-- tabs#0 -->')
    expect(tabs_html[0]).to include('Tab #1 content')
    expect(tabs_html[0]).to include('Tab #2 content')
    expect(tabs_html[0]).to include('&lt;%= maglev_block.setting_tag :title, html_tag: :h2 %&gt;')
  end
end
