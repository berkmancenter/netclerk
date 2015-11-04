require 'spec_helper'

describe 'pages/edit' do
  subject { rendered }

  let(:page) { create(:page) }

  before do
    assign(:page, page)

    render
  end

  it { should have_css('h1', text: 'Edit Page') }
  it { should have_css("form#edit_page_#{page.id}") }
end
