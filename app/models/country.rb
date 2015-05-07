class Country < ActiveRecord::Base
  has_many :proxies
  has_many :statuses

  scope :having_requests_on, -> ( date ) {
    where( %Q|id IN ( SELECT DISTINCT "country_id" FROM "requests" WHERE ( CAST( "created_at" AS DATE ) = '#{date.to_s}' ) )| )
  }
  scope :has_statuses, ->{ where("id IN (#{Status.all_recent.select(:country_id).distinct.to_sql})") }
end
