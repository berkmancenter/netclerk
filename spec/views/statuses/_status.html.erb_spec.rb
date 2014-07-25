require 'spec_helper'

describe ( 'statuses/status' ) {
  subject { rendered }

  let ( :chn ) { Country.find_by_name 'China' }
  let ( :page ) { Page.find_by_title 'The White House' }
  let ( :status ) { Status.most_recent.find_by( country: chn, page: page ) }
  
  
  before {
    render status
  }

  it {
    should have_css 'img[src="http://www.google.com/s2/favicons?domain=www.whitehouse.gov"]'
  }

  it {
    should have_css 'span', text: 'The White House is not available in'
  }
  
  it {
    should have_css 'b', 'China'
  }
}
