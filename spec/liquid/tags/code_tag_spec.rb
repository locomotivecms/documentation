require_relative '../../spec_helper'

RSpec.describe Liquid::Tags::CodeTag do
  before do
    register_liquid_tag('code', described_class)
  end

  let(:title) { 'Gemfile' }
  let(:content) do
    <<~CODE
    ```ruby
    gem 'maglevcms', '~> 2.0.0'
    gem 'maglevcms-hyperui-kit', '~> 1.2.0'
    ```
    CODE
  end

  let(:subject) { render_liquid_tag('code', content, "title=\"#{title}\"") }

  it 'renders code' do
    puts subject
    is_expected.to include('Gemfile')
  end
end
