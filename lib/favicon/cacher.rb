module Favicon::Cacher
  def self.cache(file_name, url)
    file_path = Rails.root.join(FAVICON_PATH, "#{file_name}.png")

    if expired?(file_path)
      Favicon::Retriever.retrieve(file_path, url)
    end
  end

  private

  def self.expired?(file_path)
    return true unless File.exist?(file_path)

    file_age_in_days = (Time.now - File.stat(file_path).mtime).to_i / 86400.0

    file_age_in_days > FAVICON_EXPIRATION_DAYS
  end
end
