require 'spec_helper'

describe( 'page model' ) {
  context( 'valid attributes' ) {
    let( :twitter ) { Page.find_by_title 'Twitter' }

    it {
      twitter.should be_valid

      twitter.should respond_to :url
      twitter.should respond_to :title
      twitter.should respond_to :category
    }

    it {
      twitter.category.name.should eq 'social'
    }
  }

  describe( 'create_proxy_requests' ) {
    let( :p ) { Page.find_by_title 'The White House' }

    it ( 'should make requests' ) {
      expect {
        p.create_proxy_requests
      }.to change {
        Request.count
      }.by( Proxy.count )
    }
  }
}
