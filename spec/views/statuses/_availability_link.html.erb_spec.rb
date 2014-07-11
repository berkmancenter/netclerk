require 'spec_helper'

describe ( 'statuses/availability_link' ) {
  subject { rendered }

  let ( :whitehouse_usa ) { Status.first }
  
  before {
    render partial: 'statuses/availability_link', object: whitehouse_usa
  }

  it { should have_css 'a.list-group-item' }

  it { should have_css 'a.list-group-item-success' }

  it {
    should have_css "a[href*='#{status_path whitehouse_usa}']"
  }

  it {
    should_not have_css 'a[title*="whitehouse.gov"]'
  }

  it {
    should have_css 'a span', text: 'Available on 2014-07-11'
  }
  
  it {
    should_not have_css 'a span', text: 'The White House'
  }
  
  it {
    should_not have_css 'a b', 'United Statues'
  }

  it {
    should_not have_css 'a img'
  }
}
