require 'spec_helper'

describe ( 'statuses/availability' ) {
  subject { rendered }

  let ( :chn ) { Country.find_by_name 'China' }
  let ( :page ) { Page.find_by_title 'The White House' }
  let ( :status ) { Status.most_recent.find_by( country: chn, page: page ) }
  
  before {
    render partial: 'statuses/availability', object: status
  }

  it {
    should_not have_css 'img[src="http://www.google.com/s2/favicons?domain=www.whitehouse.gov"]'
  }

  it {
    should have_css 'span', text: 'Not available on 2014-07-11'
  }
  
  it {
    should_not have_css 'b', 'China'
  }
}
