require 'spec_helper'

describe 'pages/index' do
  subject { rendered }

  let(:pages) { create_list(:page, 10) }

  before do
    assign(:pages, pages)

    render
  end

  it { should have_css('h1', text: 'URLs') }
  it { should have_css('.pages-help') }
  it { should have_css('.pages-list') }
  it { should have_css('.list-group.pages-list') }
  it { should have_css('.pages-list a', count: pages.count) }
  it { should have_css('button#new-page') }
end
