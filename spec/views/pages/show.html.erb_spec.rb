require 'spec_helper'

describe 'pages/show' do
  subject { rendered }

  let(:page) { create(:page) }
  let(:countries) { create_pair(:country) }
  let(:statuses) do
    create_pair(:status, page: page, country: countries.first, value: 3) +
      create_pair(:status, page: page, country: countries.second, value: 0)
  end
  let(:status_groups) { statuses.group_by(&:value) }

  before do
    assign(:page, page)
    assign(:statuses, status_groups)

    render
  end

  it { should have_css('.media .media-body') }
  it { should have_css('.media-body .media-heading', text: page.title) }
  it { should have_css('h2', text: 'Recent') }
  it { should have_css('.list-group', count: 2) }
  it { should have_css('.list-group.pages-status-danger') }
  it { should have_css('.list-group.pages-status-success') }
  it { should have_css('.pages-status-danger .list-group-item-danger', text: 'not available') }
  it { should have_css('.pages-status-success .list-group-item-success', text: 'available') }
  it { should have_css('.list-group', text: Status::VALUES[statuses.first.value]) }
  it { should have_css('.list-group', text: Status::VALUES[statuses.last.value]) }
  it { should have_css('a.list-group-item', text: countries.first.name) }

  it 'should link to statuses' do
    should have_css("a.list-group-item[href*='#{status_path(statuses.first)}']", text: countries.first.name, count: 1)
  end
end
