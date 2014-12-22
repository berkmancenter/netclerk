module NewestStatusFinder
  def self.per_country_for_page(page)
    page.statuses
      .select("DISTINCT ON (country_id) *")
      .order(:country_id, created_at: :desc)
  end

  def self.per_page_for_country(country)
    country.statuses
      .select("DISTINCT ON (page_id) *")
      .order(:page_id, created_at: :desc)
  end

  def self.status_bar_data(country, statuses)
    data = []

    (Status::VALUES.keys).each do |value|
      frequency = statuses.select { |s| s.value == value }.count
      data << { country: country.name, status: value, frequency: frequency } if frequency > 0
    end

    data
  end
end
