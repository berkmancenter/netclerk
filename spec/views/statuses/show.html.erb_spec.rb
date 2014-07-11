require 'spec_helper'

describe ( 'statuses/show' ) {
  subject { rendered }

  context ( 'default view' ) {
    let ( :status ) { Status.first }
    let ( :statuses ) { Status.where( country: status.country, page: status.page ).order( :created_at ) }

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
