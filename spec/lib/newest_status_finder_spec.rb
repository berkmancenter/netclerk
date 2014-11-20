describe NewestStatusFinder do
  describe '.per_country_for_page' do
    let(:page) { create(:page) }
    let(:countries) { create_pair(:country) }
    let(:today_status_1) { create(:status, country: countries[0], page: page, created_at: Time.now) }
    let(:today_status_2) { create(:status, country: countries[1], page: page, created_at: Time.now) }
    let(:statuses) { NewestStatusFinder.per_country_for_page(page) }

    before do
      create(:status, country: countries[0], page: page, created_at: Date.yesterday)
      create(:status, country: countries[1], page: page, created_at: Date.yesterday)
    end

    it 'returns a collection of the most recent status for each country' do
      expect(statuses).to match_array([today_status_1, today_status_2])
    end
  end
end

