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

  def self.diff( text1, text2 )
    # return difference value of two texts
    d = DiffMatchPatch.new

    df = d.diff_main text1, text2

    diff = 0.0

    df.each { |d| 
      if d[ 0 ] == :delete
        d[ 1 ].each_char { |c|
          diff -= c.ord
        }
      elsif d[ 0 ] == :insert
        d[ 1 ].each_char { |c|
          diff += c.ord
        }
      end
    }

    total_ord = 0.0
    text1.each_char { |c|
      total_ord += c.ord
    }

    if total_ord > 0.0
      (diff / total_ord * 1000.0).round / 1000.0
    else
      0.0
    end
  end

  def to_laapi
    {
      type: 'requests',
      id: id.to_s,
      attributes: {
        url: page.present? ? page.url : nil,
        country: country.present? ? country.iso2 : nil,
        isp: nil,
        dns_ip: local_dns_ip,
        request_ip: proxied_ip,
        request_headers: nil,
        redirect_headers: nil,
        response_status: response_status,
        response_headers_time: nil,
        response_headers: response_headers,
        response_content_time: response_time,
        response_content: nil,
        created: created_at
      },
      links: {
        'self' => NetClerk::Application.routes.url_helpers.laapi_request_url( id )
      }
    }
  end
end
