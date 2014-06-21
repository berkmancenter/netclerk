require 'spec_helper'

describe ( 'countries/country' ) {
  subject { rendered }

  let ( :country ) { Country.first }
  
  before {
    render country
  }

  it { should have_css 'h2', text: country.name }
}
