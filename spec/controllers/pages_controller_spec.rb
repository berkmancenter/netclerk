require 'spec_helper'

describe ( PagesController ) {
  describe ( 'GET index' ) {
    it {
      Page.should_receive( :all )
      get :index
      response.code.should eq( '200' )
    }
  }

  describe ( 'GET page' ) {
    let ( :page ) { Page.first }

    it {
      get :show, :id => page.id

      response.code.should eq( '200' )

    }
  }

  describe ( 'GET new' ) {
    it {
      Page.should_receive( :new )
      get :new
      response.code.should eq( '200' )
    }
  }

}


