require 'spec_helper'

describe ( 'countries/country' ) {
  subject { rendered }

  let ( :country ) { Country.first } #usa
  
  before {
    render country
  }

  it { should have_css '.country' }

  it { should have_css '.media' }

  it { should have_css 'a.pull-left' }

  it { should have_css "a[href*='#{country_path country}']" }

  it { should have_css '.pull-left img' }

  it { should have_css 'img.media-object' }

  it { should have_css '.media-body' }

  it { should have_css '.media-body .media-heading', text: country.name }

  it { should have_css '.media-body .statusBarContainer' }
}
