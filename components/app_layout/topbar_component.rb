class AppLayout::TopbarComponent < ViewComponent::Base
  include SettingsHelper

  renders_one :links

  attr_reader :pages, :current_page

  def initialize(current_page:, pages:)
    @pages = pages
    @current_page = current_page
  end
end
