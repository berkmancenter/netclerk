require 'spec_helper'

describe( 'status model' ) {
  context( 'valid attributes' ) {
    let( :status ) { Status.first }

    it {
      status.should be_valid
    }

    it { status.should respond_to :page }
    it { status.should respond_to :country }
    it { status.should respond_to :value }
    it { status.should respond_to :delta}
  }
}
