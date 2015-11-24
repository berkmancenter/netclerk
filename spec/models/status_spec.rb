describe Status do
  let(:page) { create(:page) }
  let(:country) { create(:country) }
  let!(:yesterday_request) { create(:request, page: page, country: country, response_status: '200', created_at: Date.yesterday) }
  let!(:today_request) { create(:request, page: page, country: country, response_status: '404', created_at: Date.current) }

  it { should respond_to(:value, :delta, :page_url, :page_title, :country_name) }
  it { should belong_to(:page) }
  it { should belong_to(:country) }
  it { should validate_inclusion_of(:value).in_array(Status::VALUES.keys) }

  it 'has a valid factory' do
    expect(build(:status)).to be_valid
  end

  it 'defines valid status values in VALUES' do
    expect(Status::VALUES).to eq(
      0 => 'not available',
      1 => 'very different',
      2 => 'a bit different',
      3 => 'available'
    )
  end

  describe 'a created status' do
    let(:today_status_first) { create(:status, page: page, country: country, created_at: Date.today) }
    let(:today_status_second) { build(:status, page: page, country: country, created_at: Date.today) }
    let(:yesterday_status) { create(:status, page: page, country: country, created_at: Date.yesterday) }

    it 'is invalid without a unique combination of page, country, and date' do
      expect(today_status_first).to be_valid
      expect { today_status_second.save! }.to raise_error
    end

    it 'is valid with a unique combination of page, country, and date' do
      expect(today_status_first).to be_valid
      expect(yesterday_status).to be_valid
    end
  end

  describe '.create_for_date' do
    let(:yesterday_status) { Status.create_for_date(page, country, Date.yesterday) }
    let(:today_status) { Status.create_for_date(page, country, Date.current) }

    it 'creates a status' do
      expect { yesterday_status }.to change { Status.count }.by(1)
    end

    it 'sets request_ids' do
      expect(yesterday_status.requests).not_to be_empty
    end

    it 'sets the status value' do
      expect(yesterday_status.value).to be(3)
      expect(today_status.value).to be(0)
    end

    context 'with a previous status' do
      it 'calculates the delta of the status by comparing it to the previous status' do
        yesterday_status

        expect(today_status.delta).to eq(-3)
      end
    end

    context 'without a previous status' do
      it 'sets delta to 0' do
        expect(today_status.delta).to eq(0)
      end
    end
  end

  describe 'scopes' do
    let!(:status) { Status.create_for_date(page, country, Date.current) }
    let(:other_country) { create(:country) }
    let!(:other_country_request) { create(:request, page: page, country: other_country, created_at: Date.current) }
    let!(:other_country_status) { Status.create_for_date(page, other_country, Date.current) }

    describe '.most_recent' do
      let(:most_recent) { Status.most_recent }

      it 'returns a collection containing the most recent statuses' do
        expect(most_recent).to include(status, other_country_status)
      end
    end

    describe '.most_recent_for_country' do
      let(:most_recent_for_country) { Status.most_recent_for_country(country) }

      it 'returns a collection containing the most recent statuses for a country' do
        expect(most_recent_for_country).to include(status)
        expect(most_recent_for_country).not_to include(other_country_status)
      end
    end
  end
end
