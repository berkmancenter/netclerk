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
}
