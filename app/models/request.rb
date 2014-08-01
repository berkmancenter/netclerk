class Request < ActiveRecord::Base
  belongs_to :page
  belongs_to :country
  belongs_to :proxy

  def self.value( requests )
    # store some stats useful for final calc

    # guarntee these
    info_by_status = Hash[
      '200', {
        count: 0,
        time: 0,
        length: 0,
        delta: 0
      },

      '404', {
        count: 0,
        time: 0,
        length: 0,
        delta: 0
      },

      '500', {
        count: 0,
        time: 0,
        length: 0,
        delta: 0
      }
    ]

    requests.each { |r|
      info = info_by_status[ r.response_status.to_s ]

      if info.present?
        info[ :count ] += 1
        info[ :time ] += r.response_time
        info[ :length ] += r.response_length
        info[ :delta ] += r.response_delta
      end
    }

    # average by response_status
    info_by_status.each { |k, v|
      count = v[ :count ]
      next if count == 0

      v[ :time ] /= count
      v[ :length ] /= count
      v[ :delta ] /= count
    }

    if info_by_status[ '200' ][ :count ] == 0 || info_by_status[ '404' ][ :count ] > info_by_status[ '200' ][ :count ]
      return 3
    end

    avg_delta = info_by_status[ '200' ][ :delta ]

    if avg_delta > 0.75
      return 2
    elsif avg_delta > 0.40
      return 1
    else
      return 0
    end
  end
end
