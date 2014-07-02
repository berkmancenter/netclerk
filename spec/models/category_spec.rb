require 'spec_helper'

describe( 'category model' ) {
  context( 'valid attributes' ) {
    let( :social ) { Category.find_by_name 'social' }

    it {
      social.should be_valid

      social.should respond_to :name
    }
  }
}
