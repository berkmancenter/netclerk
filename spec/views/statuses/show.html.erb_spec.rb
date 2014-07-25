require 'spec_helper'

describe ( 'statuses/show' ) {
  subject { rendered }

  context ( 'default view' ) {
    let ( :chn ) { Country.find_by_name 'China' }
    let ( :page ) { Page.find_by_title 'The White House' }
    let ( :status ) { Status.most_recent.find_by( country: chn, page: page ) }

    let ( :statuses ) { Status.where( country: status.country, page: status.page ).order( 'created_at desc' ) }

    before {
      assign( :status, status )
      assign( :statuses, statuses )
    
      render
    }

    it {
      should have_css '.country'
    }

    it {
      should have_css '.page'
    }

    it { 
      should have_css 'h2', text: 'Recent'
    }

    it { should have_css '.statuses-list' }

    it ( 'should show status from today & yesterday' ) {
      should have_css '.statuses-list a', count: 2
    }

    it { 
      should have_css 'h2', text: 'History'
    }
  }
}
