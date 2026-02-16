class AppLayout::PageNavComponent < ViewComponent::Base
  def initialize(page_content:)
    super
    @page_content = page_content
  end

  # use nokogiri to find all the h2 and h3 tags
  def h2_and_h3_tags
    @h2_and_h3_tags ||= build_h2_and_h3_tags
  end

  def render?
    h2_and_h3_tags.any?
  end

  private

  def build_h2_and_h3_tags
    Nokogiri::HTML(@page_content).css('h2, h3').map do |tag|
      {
        text: tag.text,
        id: tag['id'],
        level: tag.name.gsub('h', '').to_i - 2,
      }
    end
  end
end
