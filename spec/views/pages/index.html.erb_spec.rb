require 'spec_helper'

describe 'pages/index' do
  subject { rendered }

  let(:pages) { create_list(:page, 10) }
  let(:categories) { create_pair(:category) }

  before do
    assign(:pages, pages)
    assign(:categories, categories)

    render
  end

  it { should have_css('h1', text: 'URLs') }
  it { should have_css('.pages-help') }
  it { should have_css('.pages-list') }
  it { should have_css('.list-group.pages-list') }
  it { should have_css('.pages-list a', count: pages.count) }
  it { should have_css('button#new-page') }
end
