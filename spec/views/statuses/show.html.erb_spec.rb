require 'spec_helper'

describe ( 'statuses/show' ) {
  subject { rendered }

  context ( 'default view' ) {
    let ( :c ) { Country.find_by_name 'China' }
    let ( :page ) { Page.find_by_title 'The White House' }
    let ( :status ) { Status.most_recent.find_by( country: c, page: page ) }

    let ( :previous_statuses ) do
      Status.where( country: status.country, page: status.page ).order( 'created_at desc' ).offset(1)
    end

    before {
      assign( :status, status )
      assign( :previous_statuses, previous_statuses )
    
      render
    }

    it {
      should have_css '.country'
    }

    it {
      should have_css '.page'
    }

    it { 
      should have_css 'h4', text: 'Previous'
    }

    it { should have_css '.statuses-list' }

    it ( 'should show status from yesterday' ) {
      should have_css '.statuses-list a', count: 1
    }
  }
}
