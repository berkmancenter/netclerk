module PagesHelper
  def favicon_tag(page_id, options = {})
    params = {
      alt: 'Favicon',
      width: 16,
      height: 16,
    }

    favicon_path = "favicons/#{page_id}.png"

    unless Rails.application.assets.find_asset(favicon_path)
      favicon_path = "default_favicon.png"
    end

    image_tag(
      favicon_path,
      params.merge(options),
    )
  end
end
