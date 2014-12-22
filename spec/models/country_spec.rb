require 'spec_helper'

describe Country do
  it { should have_many(:statuses) }
  it { should have_many(:proxies) }
  it { should respond_to(:name, :iso3, :local_dns) }

  it 'has a valid factory' do
    expect(build(:country)).to be_valid
  end
end
