require 'spec_helper'

describe( 'proxy model' ) {
  context( 'valid attributes' ) {
    let( :proxy_usa ) { Proxy.first }

    it {
      proxy_usa.should be_valid

      proxy_usa.should respond_to :ip_and_port
      proxy_usa.should respond_to :permanent
      proxy_usa.should respond_to :country
    }

    it {
      split = proxy_usa.ip_and_port.split( ':' )
      split.count.should eq( 2 )
    }

    it {
      proxy_usa.country.iso3.should eq 'USA'
    }
  }
}
