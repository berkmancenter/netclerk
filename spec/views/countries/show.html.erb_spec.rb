require 'spec_helper'

describe ( 'countries/show' ) {
  subject { rendered }

  context ( 'default view' ) {
    let ( :country ) { Country.first }

    before {
      assign( :country, country )
    
      render
    }

    it { should have_css '.media .media-body' }

    it { should have_css '.media-body .media-heading', text: country.name }
  }
}
