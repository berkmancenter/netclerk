require 'spec_helper'

describe ( 'statuses/availability' ) {
  subject { rendered }

  let ( :status ) { Status.first }
  
  before {
    render partial: 'statuses/availability', object: status
  }

  it {
    should_not have_css 'img[src="http://www.google.com/s2/favicons?domain=www.whitehouse.gov"]'
  }

  it {
    should have_css 'span', text: 'Available on 2014-07-11'
  }
  
  it {
    should_not have_css 'b', 'United States'
  }
}
