require 'spec_helper'

describe Page do
  it { is_expected.to have_and_belong_to_many :categories }
  it { is_expected.to have_many :statuses }
  it { is_expected.to ensure_length_of(:url).is_at_most(2048) }
  it { is_expected.to respond_to(:url, :title, :failed_at, :fail_count) }

  it 'has a valid factory' do
    expect(build(:page)).to be_valid
  end

  it 'has a factory for creating a page with associated categories' do
    expect(create(:page_with_categories, categories_count: 5).categories.size).to eq(5)
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

  describe 'scope: category' do
    let(:category) { create(:category) }
    let!(:page_without_category) { create(:page) }
    let!(:pages_with_category) { create_pair(:page, categories: [category]) }
    let(:scope) { Page.category(category.name) }

    it 'filters pages by category' do
      expect(scope).not_to include(page_without_category)
      expect(scope).to include(*pages_with_category)
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

  describe '#category_names' do
    let(:categories) { create_list(:category, 3) }
    let(:page) { create(:page, categories: categories) }
    let(:category_names) { page.category_names }

    it 'returns an array of names of categories associated with the page' do
      expect(category_names).to match_array(categories.map(&:name))
    end
  end
end
