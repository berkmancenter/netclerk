require 'spec_helper'

describe( 'request model' ) {
  context( 'valid attributes' ) {
    let( :request ) { Request.first }

    it {
      request.should be_valid
    }

    it { request.should respond_to :page }
    it { request.should respond_to :country }
    it { request.should respond_to :proxy }
    it { request.should respond_to :unproxied_ip }
    it { request.should respond_to :proxied_ip }
    it { request.should respond_to :local_dns_ip }
    it { request.should respond_to :response_time }
    it { request.should respond_to :response_status }
    it { request.should respond_to :response_headers }
    it { request.should respond_to :response_length }
    it { request.should respond_to :response_delta }
  }

  describe( 'value' ) {
    let( :p ) { Page.find_by_title 'The White House' }
    let( :c ) { Country.find_by_name 'United States' }
    let( :rs ) { Request.where( page: p, country: c, created_at: '2014-07-12' ) }
      
    it {
      Request.value( rs ).should eq( 1 )
    }
  }

  describe( 'diff' ) {
    context ( 'with equal' ) {
      it {
        d = Request.diff( '00000', '00000' )
        d.should eq( 0 )
      }
    }

    context ( 'with one delete and insert' ) {
      it {
        d = Request.diff( '00000', '00100' )
        d.should eq( 0.004 )
      }
    }

    context ( 'with one move' ) {
      it {
        d = Request.diff( '01000', '00010' )
        d.should eq( 0 )
      }
    }

    context ( 'with html and language change' ) {
      it {
        d = Request.diff( '<body><h1>Hello!</h1></body>', '<body><h1>Bonjour!</h1></body>' )
        d.should eq( 0.103 )
      }
    }
  }
}
