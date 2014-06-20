require 'spec_helper'

describe ( 'countries/index' ) {
  subject { rendered }

  context ( 'default view' ) {
    before {
      assign( :countries, Country.all )
    
      render
    }

    it { should have_css 'h1', text: 'Countries' }

    it { should have_css 'ul.countries' }
  }
}
