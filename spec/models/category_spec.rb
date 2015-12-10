describe Category do
  it 'has a valid factory' do
    expect(create(:category)).to be_valid
  end

  it { is_expected.to have_and_belong_to_many(:pages) }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }

  describe 'scope: has_pages' do
    let!(:categories_with_pages) { create_pair(:category) }
    let!(:pages) { create(:page, categories: categories_with_pages) }
    let!(:category_without_pages) { create(:category) }
    let(:scope) { Category.has_pages }

    it 'filters out categories without pages' do
      expect(scope).not_to include(category_without_pages)
      expect(scope).to include(*categories_with_pages)
    end
  end
end
