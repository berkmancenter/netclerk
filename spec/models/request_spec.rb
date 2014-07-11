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
}
