require 'spec_helper'

describe 'statuses/status' do
  subject { rendered }

  context 'for a normal status' do
    let(:status) { create(:status) }

    before { render status }

    it { should have_xpath "//img[contains(@alt, \"Favicon\")]" }
    it { should have_css 'span', text: "#{status.page_title} is #{Status::VALUES[status.value]} in #{status.country_name}" }
    it { should have_css 'b', status.country_name }
  end

  context 'for a status without a page title' do
    let(:page) { create(:page, title: nil) }
    let(:status) { create(:status, page: page) }

    before { render status }

    it { should have_css 'span', text: status.page_url }
  end
end
