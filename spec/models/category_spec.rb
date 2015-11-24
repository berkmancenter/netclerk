describe Category do
  it 'has a valid factory' do
    expect(create(:category)).to be_valid
  end

  it { is_expected.to respond_to(:name) }
end
