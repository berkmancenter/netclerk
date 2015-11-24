require 'spec_helper'

describe Page do
  it { should belong_to :category }
  it { should have_many :statuses }
  it { should ensure_length_of(:url).is_at_most(2048) }
  it { should respond_to(:url, :title, :failed_at, :fail_count) }

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

  describe 'scope: requestable' do
    let!(:failing_page) { create(:page, fail_count: 3) }
    let!(:requestable_page) { create(:page, fail_count: 0) }
    let!(:borderline_page) { create(:page, fail_count: 2) }

    it 'returns records with fail_count < 3' do
      expect(Page.requestable.count).to eq(Page.count - 1)
    end
  end

  describe '#mark_as_failed_today!' do
    let(:page) { create(:page) }

    context 'when failed_at equals the current date' do
      let(:page) { create(:page, failed_at: Date.current) }

      it 'does not increment fail_count' do
        expect { page.mark_as_failed_today! }.not_to change { page.fail_count }
      end

      it 'does not change failed_at' do
        expect { page.mark_as_failed_today! }.not_to change { page.failed_at }
      end
    end

    context 'when failed_at does not equal the current date' do
      it 'increments fail_count' do
        expect { page.mark_as_failed_today! }.to change { page.fail_count }.by(1)
      end

      it 'sets failed_at to the current date' do
        expect { page.mark_as_failed_today! }.to change { page.failed_at }.from(nil).to(Date.current)
      end
    end
  end

  describe '#reset_failures!' do
    let(:page) { create(:page, failed_at: Date.yesterday, fail_count: 3) }

    it 'resets failed_at to nil' do
      expect { page.reset_failures! }.to change { page.failed_at }.from(Date.yesterday).to(nil)
    end

    it 'resets fail_count to 0' do
      expect { page.reset_failures! }.to change { page.fail_count }.from(3).to(0)
    end
  end
end
