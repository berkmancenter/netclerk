require 'spec_helper'

describe ( 'countries/link_item' ) {
  subject { rendered }

  let ( :country ) { Country.first }
  
  before {
    render partial: 'countries/link_item', object: country
  }

  it { should have_css 'li' }

  it { should have_css 'li a' }
}
