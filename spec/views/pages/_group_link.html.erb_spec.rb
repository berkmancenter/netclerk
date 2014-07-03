require 'spec_helper'

describe ( 'pages/group_link' ) {
  subject { rendered }

  let ( :twitter ) { Page.find_by_title 'Twitter' }
  
  before {
    render partial: 'pages/group_link', object: twitter
  }

  it { should have_css 'a.list-group-item' }

  it {
    should have_css "a[href*='#{page_path twitter}']"
  }

  it {
    should have_css 'a span', text: 'Twitter'
  }

  it {
    should have_css 'a img'
  }
}
