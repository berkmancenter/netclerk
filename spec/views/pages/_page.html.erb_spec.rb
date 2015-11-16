require 'spec_helper'

describe 'pages/_page' do
  subject { rendered }

  let(:page) { create(:page) }

  before { render page }

  it { should have_css('.page') }
  it { should have_css('.media') }
  it { should have_css('.favicon-container') }
  it { should have_css("a[href*='#{page_path page}']") }
  it { should have_css('img.media-object') }
  it { should have_xpath("//img[contains(@alt, \"Favicon\")]") }
  it { should have_css('.media-body') }
  it { should have_css('.media-body .media-heading', text: page.title) }
  it { should have_css('.media-body p', text: page.category.name) }

  context 'for a page with a short URL' do
    it { should have_css('p.url', text: page.url) }
  end

  context 'for a page with a long URL' do
    let(:page) { create(:page_with_long_url) }

    it { should have_css('p.truncated-url', text: truncate(page.url, length: 80)) }
    it { should have_css('p.full-url', text: page.url) }
  end
end
