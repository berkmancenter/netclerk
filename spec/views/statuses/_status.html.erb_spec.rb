require 'spec_helper'

describe ( 'statuses/status' ) {
  subject { rendered }

  let ( :status ) { Status.first }
  
  before {
    render status
  }

  it {
    should have_css 'img[src="http://www.google.com/s2/favicons?domain=www.whitehouse.gov"]'
  }

  it {
    should have_css 'span', text: 'The White House is available in'
  }
  
  it {
    should have_css 'b', 'United States'
  }
}
