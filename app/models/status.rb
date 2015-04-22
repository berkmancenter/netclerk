class Status < ActiveRecord::Base
  VALUES = {
    0 => 'available',
    1 => 'a bit different',
    2 => 'very different',
    3 => 'not available',
  }

  belongs_to :page
  belongs_to :country

  validates :value, inclusion: { in: VALUES.keys }

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

  scope :all_recent, -> { where("date(\"#{table_name}\".\"created_at\") = '#{newest_date}'") }
  scope :changed, -> { where.not(delta: 0) }

  def self.create_for_date( page, country, date )
    status = nil
    date = Date.parse( date ) if date.is_a? String
    prev_date = date.yesterday
    next_date = date.tomorrow

    requests = Request.where "page_id = #{page.id} and country_id = #{country.id} and created_at >= '#{date.to_s}' and created_at < '#{next_date.to_s}'"

    if requests.any?
      value = Request.value requests

      prev_status = Status.where( "page_id = #{page.id} and country_id = #{country.id} and created_at < '#{date.to_s}'" ).order( 'created_at desc' ).first

      delta = ( prev_status.present? ? value - prev_status.value : 0 )

      status = Status.create(
        page: page,
        country: country,
        value: value,
        delta: delta,
        created_at: date,
      )
    end

    status
  end

  def requests
    Request.where(id: request_ids)
  end

  def requests=(array)
    self.request_ids = array.collect(&:id)
  end

  def self.newest_date
    exists? ? select(:created_at).order(:created_at).last.created_at.to_date : Date.today
  end
end
