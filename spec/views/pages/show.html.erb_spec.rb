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

    it { should have_css 'h2', text: "Today's status" }

    it {
      should have_css '.list-group', count: 4
    }

    it { should have_css '.list-group .pages-status-success' }

    it {
      should have_css '.pages-status-success .list-group-item-success'
    }

    it {
      should have_css '.pages-status-success .list-group-item span', text: 'United States', count: 1
    }

    it { should have_css '.pages-status-info .list-group-item-info' }

    it { should have_css '.pages-status-warning .list-group-item-warning' }

    it {
      # china's warning status isn't from today
      should_not have_css '.pages-status-warning .list-group-item span', text: 'China'
    }

    it { should have_css '.pages-status-danger .list-group-item-danger' }

    it {
      should have_css '.pages-status-danger .list-group-item span', text: 'China', count: 1
    }
  }
}
