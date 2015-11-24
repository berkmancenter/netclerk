describe Country do
  it { is_expected.to have_many(:statuses) }
  it { is_expected.to have_many(:proxies) }
  it { is_expected.to respond_to(:name, :iso3, :local_dns) }

  it 'has a valid factory' do
    expect(build(:country)).to be_valid
  end

  describe 'scope: having_requests_on' do
    let(:scope) { Country.having_requests_on(Date.current) }
    let!(:today_requests) { create_pair(:request) }
    let!(:yesterday_requests) { create_list(:request, 3, created_at: Date.yesterday) }

    it 'should scope to request date' do
      expect(scope.size).to eq(today_requests.size)
    end
  end

  describe 'scope: has_statuses' do
    let(:scope) { Country.has_statuses }
    let!(:statuses) { create_list(:status, 3) }
    let!(:country_without_status) { create(:country) }

    it 'should include all countries having statuses' do
      # not just having most recent statuses
      expect(scope.pluck(:id)).to include(*statuses.map(&:country_id))
    end

    it 'should not include countries without a single status' do
      expect(scope.pluck(:id)).not_to include(country_without_status.id)
    end
  end
end
