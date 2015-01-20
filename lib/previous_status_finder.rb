module PreviousStatusFinder
  def self.statuses(timestamp, country_id, page_id, limit = 5)
    Status
      .where(country_id: country_id)
      .where(page_id: page_id)
      .where("created_at < '#{timestamp}'")
      .order('created_at desc')
      .limit(limit)
  end
end
