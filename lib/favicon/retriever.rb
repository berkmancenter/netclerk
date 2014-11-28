module Favicon::Retriever
  def self.retrieve(file_path, url)
    file = File.new(file_path, 'w')

    file.binmode
    file << open(
      "http://www.google.com/s2/favicons?domain=#{URI.parse(url).host}"
    ).read
    file.close
  end
end
