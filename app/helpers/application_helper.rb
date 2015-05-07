module ApplicationHelper
  def title_or_url( page )
    return '' if page.nil?

    if page.title.to_s.strip.length == 0
      page.url
    else
      page.title
    end
  end

  def cache_duration
    8.hours
  end
end
