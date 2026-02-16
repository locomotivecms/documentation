class AppLayout::TopbarLinkComponent < ViewComponent::Base
  attr_reader :label, :href

  def initialize(label: nil, href:)
    @label = label
    @href = href
  end
end
