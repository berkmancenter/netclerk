require 'spec_helper'

describe 'pages/new' do
  subject { rendered }

  let(:page) { build(:page) }

  before do
    assign(:page, page)

    render
  end

  it { should have_css('h1', text: 'Add a Page') }
  it { should have_css('form#new_page') }
end
