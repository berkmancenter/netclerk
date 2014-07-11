require 'spec_helper'

describe ( 'statuses/index' ) {
  subject { rendered }

  context ( 'default view' ) {
    let ( :statuses ) { Status.all }

    before {
      assign( :statuses, statuses )
    
      render
    }

    it { should have_css 'h1', text: 'Recent' }

    it { should have_css '.statuses-list' }

    it { should have_css '.list-group.statuses-list' }

    it {
      should have_css '.statuses-list a', count: statuses.count
    }
  }
}
