require 'spec_helper'

describe Page do
  it { should belong_to :category }
  it { should have_many :statuses }
  it { should ensure_length_of(:url).is_at_most(2048) }
  it { should respond_to(:url, :title) }

  it 'has a valid factory' do
    expect(build(:page)).to be_valid
  end

  describe '#strip_trailing_slash' do
    let(:page) { create(:page, url: 'http://www.example.com/') }

    it 'removes a trailing slash from the page\'s URL' do
      expect(page).to be_valid
      expect(page.url).to eq('http://www.example.com')
    end
  end

  describe '#create_proxy_requests' do
    let(:page) { Page.find_by_title 'The White House' }

    it 'should create requests' do
      skip 'hard to keep working proxy up to date for test'
      # may remove this test & create_proxy_requests function now that we have sidekiq

      expect { p.create_proxy_requests }.to change { Request.count }.by(Proxy.count)
    end
  end

  describe '#baseline_content' do
    let(:page) { create(:page, title: 'The White House', url: 'http://www.whitehouse.gov') }

    before do
      stub_request(
        :get, page.url
      ).with(
        headers: {
          'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Accept-Language' => 'en-US,en;q=0.8',
          'Connection' => 'close',
          'User-Agent' => 'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36'
        }
      ).to_return(status: 200, body: 'The Home Page for the White House of the United States.', headers: {})

      Rails.cache.delete(page.url)

      page.baseline_content
    end

    it 'returns the page\'s baseline content' do
      expect(page.baseline_content).not_to be_empty
    end

    it 'caches the page\'s baseline content' do
      expect(Rails.cache.exist?(page.url)).to be(true)
    end
  end
end
