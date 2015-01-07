module PagesHelper
  def favicon_tag(page_id, options = {})
    params = {
      alt: 'Favicon',
      width: 16,
      height: 16,
    }

    image_tag(
      "favicons/#{page_id}.png",
      params.merge(options),
    )
  end
end
