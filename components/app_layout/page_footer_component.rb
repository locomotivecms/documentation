class AppLayout::PageFooterComponent < ViewComponent::Base
  include SettingsHelper

  attr_reader :pages, :current_page

  def initialize(pages:, current_page:)
    @pages = pages
    @current_page = current_page
  end

  def github_repo_url
    "https://github.com/#{settings.site['github_repo']}/blob/main/#{current_page.asset.path}"
  end

  def edit_page?
    current_page.data['sidebar'] != false
  end

  def next_page
    @next_page ||= SitePage.find_next_page(pages, current_page)
  end

  def render?
    edit_page?
  end
end
