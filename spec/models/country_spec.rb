require 'spec_helper'

describe Country do
  it { should have_many(:statuses) }
  it { should have_many(:proxies) }
  it { should respond_to(:name, :iso3, :local_dns) }

  it 'has a valid factory' do
    expect(build(:country)).to be_valid
  end

  describe 'having_requests_on' do
    it { Country.should respond_to( :having_requests_on ) }

    it 'should scope to request date' do
      Country.having_requests_on( '2014-07-11' ).count.should eq( 2 )
    end
  end
end
