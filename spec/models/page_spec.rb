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
}
