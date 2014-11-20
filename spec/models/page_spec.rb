require 'spec_helper'

describe Page do
  it { should belong_to :category }
  it { should have_many :statuses }

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
      pending 'hard to keep working proxy up to date for test'
      # may remove this test & create_proxy_requests function now that we have sidekiq

      expect {
        p.create_proxy_requests
      }.to change {
        Request.count
      }.by( Proxy.count )
    }
  }

  it 'has a valid factory' do
    expect(build(:page)).to be_valid
  end
end
