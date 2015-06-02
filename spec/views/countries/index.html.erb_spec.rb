require 'spec_helper'

describe ( 'countries/index' ) {
  subject { rendered }

  context ( 'default view' ) {
    let ( :countries ) { Country.has_statuses }

    before {
      assign( :countries, countries )
    
      render
    }

    it { should have_css 'h1', text: 'Countries' }

    it { should have_css 'ul.countries-list' }

    it { should have_css 'li', count: countries.count }
  }
}
