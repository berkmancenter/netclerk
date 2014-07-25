require 'spec_helper'

describe ( 'pages/show' ) {
  subject { rendered }

  context ( 'default view' ) {
    let ( :page ) { Page.find_by_title 'The White House' }
    let ( :chn ) { Country.find_by_name 'China' }
    let ( :statuses ) {
      Status.most_recent.where( page: page ).group_by { |status| status.value }
    }
    let ( :status_chn ) {
      Status.most_recent.find_by( page: page, country: chn )
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

    it { should have_css '.list-group.pages-status-danger' }
    it { should have_css '.list-group.pages-status-warning' }
    it { should have_css '.list-group.pages-status-info' }
    it { should have_css '.list-group.pages-status-success' }

    it { should have_css '.pages-status-danger .list-group-item-danger', text: 'not available' }

    it ( 'should link to statuses' ) {
      should have_css %(.pages-status-danger a.list-group-item[href*="#{status_path status_chn}"]), text: 'China', count: 1
    }

    it { should have_css '.pages-status-warning .list-group-item-warning', text: 'very different' }

    it {
      should have_css '.pages-status-warning a.list-group-item', text: 'Iran', count: 1
    }

    it {
      # china's warning status isn't from today
      should_not have_css '.pages-status-warning a.list-group-item', text: 'China'
    }

    it { should have_css '.pages-status-info .list-group-item-info', text: 'a bit different' }

    it {
      should have_css '.pages-status-info a.list-group-item', text: 'France', count: 1
    }

    it { should have_css '.pages-status-success .list-group-item-success', text: 'available' }

    it {
      should have_css '.pages-status-success a.list-group-item', text: 'United States', count: 1
    }
  }
}

