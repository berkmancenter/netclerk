require 'spec_helper'

describe ( 'pages/show' ) {
  subject { rendered }

  context ( 'default view' ) {
    let ( :page ) { Page.first }

    before {
      assign( :page, page )
    
      render
    }

    it { should have_css '.media .media-body' }

    it { should have_css '.media-body .media-heading', text: page.title }
  }
}
