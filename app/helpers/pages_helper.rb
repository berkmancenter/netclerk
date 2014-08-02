module PagesHelper
  def title_or_url( page )
    if page.title.to_s.strip.length == 0
      page.url
    else
      page.title
    end
  end
end
