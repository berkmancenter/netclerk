require 'spec_helper'

describe ( 'statuses/status' ) {
  subject { rendered }

  let ( :country ) { Country.find_by_name 'Iran' }

  context ( 'normal status' ) {
    let ( :page ) { Page.find_by_title 'The White House' }
    let ( :status ) { Status.most_recent.find_by( country: country, page: page ) }
    
    before {
      render status
    }

    it { should have_xpath "//img[contains(@alt, \"Favicon\")]" }

    it {
      should have_css 'span', text: 'The White House is very different in'
    }
    
    it {
      should have_css 'b', 'Iran'
    }
  }

  context ( 'without title' ) {
    let ( :page ) { Page.find_by_url 'http://www.no-title.com' }
    let ( :status ) { Status.most_recent.find_by( country: country, page: page ) }
    
    before {
      render status
    }

    it {
      should have_css 'span', text: 'www.no-title.com'
    }
    
  }
}
