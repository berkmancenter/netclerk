describe NewestStatusFinder do
  let(:page) { create(:page) }
  let(:countries) { create_pair(:country) }
  let!(:old_status_1) { create(:status, country: countries[0], page: page, created_at: 1.month.ago) }
  let!(:old_status_2) { create(:status, country: countries[1], page: page, created_at: 1.month.ago) }
  let!(:today_status_1) { create(:status, country: countries[0], page: page, created_at: Time.now) }
  let!(:today_status_2) { create(:status, country: countries[1], page: page, created_at: Time.now) }

  describe '.per_country_for_page' do
    let(:statuses) { NewestStatusFinder.per_country_for_page(page) }

    it 'returns a collection of the most recent status for each country' do
      expect(statuses).to match_array([today_status_1, today_status_2])
    end
  end

  describe '.per_page_for_country' do
    let(:statuses) { NewestStatusFinder.per_page_for_country(countries[0]) }

    it 'returns a collection of the most recent status for each page' do
      expect(statuses).to match_array([today_status_1])
    end
  end

  describe '.status_bar_data' do
    let(:country) { create(:country) }
    let(:data) { NewestStatusFinder.status_bar_data(country, statuses) }
    let(:available_statuses) { create_list(:status, 5, country: country, value: 0) }
    let(:very_different_statuses) { create_list(:status, 3, country: country, value: 2) }
    let!(:statuses) { available_statuses + very_different_statuses }

    it 'returns an array of hashes for populating status bars' do
      expect(data).to match_array(
        [
          { country: country.name, status: 0, frequency: 5 },
          { country: country.name, status: 2, frequency: 3 },
        ]
      )
    end
  end

  describe '.random' do
    let!(:old_statuses) { create_list(:status, 2, created_at: 1.week.ago) }
    let!(:recent_statuses) { create_list(:status, 5, created_at: Time.now) }
    let(:size) { 3 }
    let(:random_statuses) { NewestStatusFinder.random(size) }

    it 'returns the correct number of statuses' do
      expect(random_statuses.size).to eq(size)
    end

    it 'returns statuses from the most recent scan' do
      expect(random_statuses.map{ |s| s.created_at.to_date }.uniq).to eq([Status.order(:created_at).last.created_at.to_date])
    end
  end
end
