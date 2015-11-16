require 'spec_helper'

describe 'pages/form' do
  subject { rendered }

  let(:page) { create(:page) }

  before do
    assign(:page, page)

    render partial: 'pages/form'
  end

  it { should have_field('page_url') }
  it { should have_field('page_title') }
  it { should have_field('page_category_id') }
end
