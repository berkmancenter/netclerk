require 'spec_helper'

describe ( 'pages/index' ) {
  subject { rendered }

  context ( 'default view' ) {
    let ( :pages ) { Page.all }

    before {
      assign( :pages, pages )
    
      render
    }

    it { should have_css 'h1', text: 'URLs' }

    it {
      should have_css '.pages-help', text: 'Check the availability'
    }

    it { should have_css '.pages-list' }

    it { should have_css '.list-group.pages-list' }

    it {
      should have_css '.pages-list a', count: pages.count
    }
  }
}
