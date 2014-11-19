require 'spec_helper'

describe Status do
  describe( 'create_for_date' ) {
    let( :p ) { Page.find_by_title 'The White House' }
    let( :c ) { Country.find_by_name 'United States' }

    it ( 'should create a status' ) {
      expect {
        Status.create_for_date p, c, '2014-07-12'
      }.to change {
        Status.count
      }.by( 1 )
    }

    context( 'with value somewhat different' ) {
      before {
        Status.create_for_date p, c, '2014-07-12'
      }

      it {
        Status.last.value.should eq( 1 )
      }
    }

    context( 'with delta eq 1' ) {
      before {
        Status.create_for_date p, c, '2014-07-12'
      }

      it {
        Status.last.delta.should eq( 1 )
      }
    }
  }

  it { should respond_to(:page, :country, :value, :delta) }
  it { should belong_to(:page) }
  it { should belong_to(:country) }

  it 'has a valid factory' do
    expect(build(:twitter_usa)).to be_valid
  end
end
