
module PageHelper
  def link_to_page(page)
    link_to page.data.fetch("title", page.request_path), page.request_path
  end

  def link_to_if_current(text, page, **kwargs)
    if page == current_page
      kwargs[:class] = kwargs[:active_class]
    end
    link_to text, page.request_path, **kwargs
  end
end
