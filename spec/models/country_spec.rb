require 'spec_helper'

describe( 'country model' ) {
  context( 'valid attributes' ) {
    let( :usa ) { Country.find_by_iso3 'USA' }

    it {
      usa.should be_valid

      usa.should respond_to :name
      usa.should respond_to :iso3
      usa.should respond_to :local_dns
    }

    it {
      usa.should respond_to :proxies
    }
  }
}
