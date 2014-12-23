require 'favicon/retriever'

module Favicon
  describe Cacher do
    describe '.favicon' do
      let(:file_name) { '1' }
      let(:file_path) { Rails.root.join(FAVICON_PATH, "#{file_name}.png") }
      let(:url) { 'http://www.example.com' }

      it 'calls Favicon::Retriever if the cached favicon has expired' do
        allow(Cacher).to receive(:expired?) { true }
        stub_const('Favicon::Retriever', double)
        expect(Favicon::Retriever).to receive(:retrieve).with(file_path, url)

        Favicon::Cacher.cache(file_name, url)
      end

      it 'does not call Favicon::Retriever if the cached favicon has not expired' do
        allow(Cacher).to receive(:expired?) { false }
        stub_const('Favicon::Retriever', double)
        expect(Favicon::Retriever).not_to receive(:retrieve)

        Favicon::Cacher.cache(file_name, url)
      end
    end
  end
end
