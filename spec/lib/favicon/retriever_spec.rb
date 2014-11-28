require 'favicon/retriever'

module Favicon
  describe Retriever do
    describe '.retrieve' do
      let(:file_path) { Rails.root.join(FAVICON_PATH, '1.ico') }
      let(:url) { 'http://www.example.com' }
      let(:file) { double }

      it "creates a local copy of a site's favicon" do
        allow(Retriever).to receive(:open) { double(read: double) }

        expect(File).to receive(:new).with(file_path, 'w') { file }
        expect(file).to receive(:binmode)
        expect(file).to receive('<<')
        expect(file).to receive(:close)

        Retriever.retrieve(file_path, url)
      end
    end
  end
end
