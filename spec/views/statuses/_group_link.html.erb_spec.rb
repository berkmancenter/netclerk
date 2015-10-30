require 'spec_helper'

describe 'statuses/group_link' do
  subject { rendered }

  let(:status) { create(:status) }

  before { render partial: 'statuses/group_link', object: status }

  it { should have_css('a.list-group-item') }
  it { should have_css('a.list-group-item-success') }
  it { should have_css("a[href*='#{status_path(status)}']") }
  it { should have_css("a[title*='#{status.page_url}']") }
  it { should have_css('a span', text: status.page_title) }
  it { should have_css('a b', status.country_name) }
  it { should have_css('a img') }
end
