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

    it ( 'should set request_ids' ) {
      s = Status.create_for_date p, c, '2014-07-12'
      s.requests.empty?.should be false
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

    context( 'with no pevious status' ) {
      let( :p2 ) { Page.find_by_title 'Berkman Center' }
      let( :c2 ) { Country.find_by_name 'China' }

      before {
        Status.create_for_date p2, c2, '2014-07-11'
      }

      it {
        Status.last.delta.should eq( 0 )
      }
    }
  }

  it { should respond_to(:page, :country, :value, :delta) }
  it { should belong_to(:page) }
  it { should belong_to(:country) }
  it { should validate_inclusion_of(:value).in_array(Status::VALUES.keys) }

  it 'has a valid factory' do
    expect(build(:status)).to be_valid
  end

  it 'defines valid status values in VALUES' do
    expect(Status::VALUES).to eq(
      {
        0 => 'available',
        1 => 'a bit different',
        2 => 'very different',
        3 => 'not available',
      }
    )
  end
end
