require 'spec_helper'

describe ( Laapi::RequestsController ) {
  let ( :r_attr_required ) {
    {
      data: {
        type: 'requests'
      }
    }
  }

  describe ( 'GET requests/3' ) {
    it ( 'should return ok' ) {
      get :show, id: 3, format: :json
      response.code.should eq( '200' )
    }
  }

  describe ( 'POST requests' ) {
    context ( 'all required fields' ) {
      it ( 'should return ok' ) {
        post :create, data: r_attr_required, format: :json
        response.code.should eq( '200' )
      }
    }
  }
}
