require 'spec_helper'

describe ( 'pages/icon_title' ) {
  subject { rendered }

  let ( :twitter ) { Page.find_by_title 'Twitter' }
  
  before {
    render partial: 'pages/icon_title', object: twitter
  }

  it {
    should have_css 'img'
  }

  it {
    should have_css 'img[src="http://www.google.com/s2/favicons?domain=twitter.com"]'
  }

  it {
    should have_css 'span', text: 'Twitter'
  }

  it {
    should have_css 'img~span'
  }
}
