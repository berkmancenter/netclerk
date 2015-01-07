require 'spec_helper'

describe ( 'pages/icon_title' ) {
  subject { rendered }

  context ( 'with all data' ) {
    let ( :twitter ) { Page.find_by_title 'Twitter' }
    
    before {
      render partial: 'pages/icon_title', object: twitter
    }

    it {
      should have_css 'img'
    }

    it {
      should have_xpath "//img[contains(@src, \"#{twitter.id}.png\")]"
    }

    it {
      should have_css 'span', text: 'Twitter'
    }

    it {
      should have_css 'img~span'
    }
  }

  context ( 'no title' ) {
    let ( :no_title ) { Page.find_by_url 'http://www.no-title.com' }
    
    before {
      render partial: 'pages/icon_title', object: no_title
    }

    it {
      should have_css 'span', text: no_title.url
    }
  }
}
