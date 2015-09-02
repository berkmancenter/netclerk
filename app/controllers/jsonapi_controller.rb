class JsonapiController < ApplicationController
  def index
    response.headers[ 'Access-Control-Allow-Origin' ] = '*'

    c = Country.find_by iso2: params[ :country ].upcase unless params[ :country ].nil?

    @statuses = c.present? ? Status.most_recent_for_country( c ) : Status.all_recent

    urls = params[ :url ]
    urls = [ urls ] unless urls.is_a?( Array )

    if urls.any?
      # filter statuses by page
    end

    api_data = {
      data: @statuses.map { |s|
        {
          type: 'statuses',
          id: s.id.to_s,
          attributes: {
            url: s.page.url,
            country: s.country.iso2,
            code: 200,
            probability: s.value.to_f / 3.0,
            available: s.value.to_f >= 2.0,
            created: s.created_at
          }
        }

      }
    }
      
    response.headers[ 'Content-Type' ] = 'application/vnd.api+json'
    render json: api_data
  end
end
