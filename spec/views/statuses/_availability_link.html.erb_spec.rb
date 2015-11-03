require 'spec_helper'

describe 'statuses/availability_link' do
  subject { rendered }

  let(:status) { create(:status) }

  before { render partial: 'statuses/availability_link', object: status }

  it { should have_css('a.list-group-item') }
  it { should have_css('a.list-group-item-success') }
  it { should have_css("a[href*='#{status_path(status)}']") }
  it { should have_css('a span', text: "#{Status::VALUES[status.value].capitalize} on #{status.created_at.to_formatted_s(:year_month_day)}") }
  it { should_not have_css("a[title*='#{status.page_url}']") }
  it { should_not have_css('a span', text: status.page_title) }
  it { should_not have_css('a b', status.country_name) }
  it { should_not have_css('a img') }
end
