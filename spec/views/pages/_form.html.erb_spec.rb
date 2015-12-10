require 'spec_helper'

describe 'pages/form' do
  subject { rendered }

  let(:page) { create(:page_with_categories) }

  before do
    assign(:page, page)

    render partial: 'pages/form'
  end

  it { should have_field('page_url') }
  it { should have_field('page_title') }
  it { should have_field('page[category_ids][]') }
end
