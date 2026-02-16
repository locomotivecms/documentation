class AppLayout::SidebarComponent < ViewComponent::Base
  include PageHelper

  attr_reader :site, :current_page, :pages

  def initialize(site:, current_page:, pages:)
    @site = site
    @current_page = current_page
    @pages = pages
  end
end
