require_relative '../../spec_helper'

RSpec.describe Liquid::Tags::HintTag do
  before do
    register_liquid_tag('hint', described_class)
  end

  let(:content) { 'This is a hint!' }

  def render_hint(style)
    render_liquid_tag('hint', content, "style=\"#{style}\"")
  end

  it 'renders info style' do
    html = render_hint('info')
    expect(html).to include('border-yellow-400')
    expect(html).to include('fa-info-circle')
    expect(html).to include(content)
  end

  it 'renders warning style' do
    html = render_hint('warning')
    expect(html).to include('border-red-400')
    expect(html).to include('fa-exclamation-triangle')
    expect(html).to include(content)
  end

  it 'renders success style' do
    html = render_hint('success')
    expect(html).to include('border-green-400')
    expect(html).to include('fa-check-circle')
    expect(html).to include(content)
  end

  it 'unescapes HTML in content' do
    html = render_hint('info')
    expect(html).to include('This is a hint!')
  end

  it 'returns nil for unknown style' do
    html = render_hint('unknown')
    expect(html).to include('class="border-l-4 p-4 "')
    expect(html).to include(content)
  end

  context 'with markdown content' do
    let(:content) { 'This is a **hint**!' }
    it 'renders markdown content' do
      html = render_hint('info')
      expect(html).to include('<p>This is a <strong>hint</strong>!</p>')
    end
  end
end
