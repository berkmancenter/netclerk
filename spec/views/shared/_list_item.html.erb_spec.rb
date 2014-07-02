require 'spec_helper'

describe ( 'shared/list_item' ) {
  subject { rendered }

  let ( :country ) { Country.first }
  
  before {
    render partial: 'shared/list_item', object: country
  }

  it {
    # removed, part of country partial
    should_not have_css 'li.media'
  }
}
