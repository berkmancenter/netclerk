module NewestStatusFinder
  def self.per_country_for_page(page)
    page.statuses
      .select("DISTINCT ON (country_id) *")
      .order(:country_id, created_at: :desc)
  end
end
