require 'spec_helper'

describe ( 'shared/list_item' ) {
  subject { rendered }

  let ( :country ) { Country.first }

  context ( 'default' ) {
    before {
      render partial: 'shared/list_item', object: country
    }

    it { should have_css 'li' }

    it {
      # removed, part of country partial
      should_not have_css 'li.media'
    }
  }

  context ( 'with extra class' ) {
    before {
      render partial: 'shared/list_item', object: country, locals: { classes: 'list-group-item' }
    }

    it { should have_css 'li.list-group-item' }
  }

}
