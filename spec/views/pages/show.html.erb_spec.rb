require 'spec_helper'

describe ( 'pages/show' ) {
  subject { rendered }

  context ( 'default view' ) {
    let ( :page ) { Page.find_by_title 'The White House' }
    let ( :statuses ) {
      Status.most_recent.where( page: page ).group_by { |status| status.value }
    }

    before {
      assign( :page, page )
      assign( :statuses, statuses )
    
      render
    }

    it { should have_css '.media .media-body' }

    it { should have_css '.media-body .media-heading', text: page.title }

    it { should have_css 'h2', text: "Today's status" }

    it {
      should have_css '.list-group', count: 4
    }

    it { should have_css '.list-group.pages-status-success' }
    it { should have_css '.list-group.pages-status-info' }
    it { should have_css '.list-group.pages-status-warning' }
    it { should have_css '.list-group.pages-status-danger' }

    it { should have_css '.pages-status-success .list-group-item-success', text: 'available' }

    it {
      should have_css '.pages-status-success a.list-group-item', text: 'United States', count: 1
    }

    it { should have_css '.pages-status-info .list-group-item-info', text: 'a bit different' }

    it { should have_css '.pages-status-warning .list-group-item-warning', text: 'very different' }

    it {
      # china's warning status isn't from today
      should_not have_css '.pages-status-warning a.list-group-item', text: 'China'
    }

    it { should have_css '.pages-status-danger .list-group-item-danger', text: 'not available' }

    it {
      should have_css '.pages-status-danger a.list-group-item', text: 'China', count: 1
    }
  }
}
