class Status < ActiveRecord::Base
  belongs_to :page
  belongs_to :country

  scope :most_recent, -> {
    joins("INNER JOIN (
      SELECT MAX(s3.created_at) AS max_id, s3.country_id
      FROM statuses AS s3
      GROUP BY s3.country_id
    ) AS s2 ON (
      statuses.country_id = s2.country_id
    ) AND
    statuses.country_id = s2.country_id AND
    statuses.created_at = s2.max_id")
  }
end
