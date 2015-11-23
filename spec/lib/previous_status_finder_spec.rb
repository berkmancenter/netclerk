describe PreviousStatusFinder do
  describe '.statuses' do
    let(:country) { create(:country) }
    let(:page) { create(:page) }
    let!(:older_statuses) { create_list(:status, 10, country: country, page: page) }
    let(:newest_status) { create(:status, country: country, page: page, created_at: Date.today) }
    let(:limit) { 4 }
    let(:previous_statuses) do
      PreviousStatusFinder.statuses(
        newest_status.created_at,
        newest_status.country_id,
        newest_status.page_id,
        limit
      )
    end

    it 'returns statuses created before the given time' do
      expect(previous_statuses.select { |s| s.created_at >= newest_status.created_at }).to be_empty
    end

    it 'returns statuses for the correct country' do
      expect(previous_statuses.select { |s| s.country_id != newest_status.country_id }).to be_empty
    end

    it 'returns statuses for the correct page' do
      expect(previous_statuses.select { |s| s.page_id != newest_status.page_id }).to be_empty
    end

    it 'returns the correct number of statuses' do
      expect(previous_statuses.size).to eq(limit)
    end
  end
end
