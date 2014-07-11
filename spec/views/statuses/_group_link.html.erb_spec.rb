require 'spec_helper'

describe ( 'statuses/group_link' ) {
  subject { rendered }

  let ( :whitehouse_usa ) { Status.first }
  
  before {
    render partial: 'statuses/group_link', object: whitehouse_usa
  }

  it { should have_css 'a.list-group-item' }

  it { should have_css 'a.list-group-item-success' }

  it {
    should have_css "a[href*='#{status_path whitehouse_usa}']"
  }

  it {
    should have_css 'a[title*="whitehouse.gov"]'
  }

  it {
    should have_css 'a span', text: 'The White House'
  }
  
  it {
    should have_css 'a b', 'United Statues'
  }

  it {
    should have_css 'a img'
  }
}
