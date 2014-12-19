describe FaviconCacherWorker do
  describe '.perform' do
    let(:page) { double(id: 1, url: 'http://www.example.com') }

    it 'calls the method for caching a favicon' do
      allow(Page).to receive(:find) { page }
      expect(Favicon::Cacher).to receive(:cache).with(page.id, page.url)

      FaviconCacherWorker.new.perform(page.id)
    end
  end
end
