require 'spec_helper'

describe ( 'statuses/availability_link' ) {
  subject { rendered }

  let ( :chn ) { Country.find_by_name 'China' }
  let ( :page ) { Page.find_by_title 'The White House' }
  let ( :status ) { Status.most_recent.find_by( country: chn, page: page ) }
  
  before {
    render partial: 'statuses/availability_link', object: status
  }

  it { should have_css 'a.list-group-item' }

  it { should have_css 'a.list-group-item-danger' }

  it {
    should have_css "a[href*='#{status_path status}']"
  }

  it {
    should_not have_css 'a[title*="whitehouse.gov"]'
  }

  it {
    should have_css 'a span', text: 'Not available on 2014-07-11'
  }
  
  it {
    should_not have_css 'a span', text: 'The White House'
  }
  
  it {
    should_not have_css 'a b', 'China'
  }

  it {
    should_not have_css 'a img'
  }
}
