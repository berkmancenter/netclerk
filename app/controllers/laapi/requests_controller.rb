class Laapi::RequestsController < ApplicationController
  protect_from_forgery with: :null_session

  def show
    response.headers[ 'Access-Control-Allow-Origin' ] = '*'

    api_data = map_requests [ Request.find(params[:id]) ]
      
    response.headers[ 'Content-Type' ] = 'application/vnd.api+json'
    render json: api_data[ :data ][ 0 ]
  end

  def create
    #data = params[ :data ]

    #respond_to { |f|
    #  f.json {
        #puts data.inspect
        render json: { data: 'ok' }, status: 200
    #  }
    #}

  end

  def map_requests( requests )
    {
      data: requests.map { |r|
        {
          type: 'requests',
          id: r.id.to_s,
          attributes: {
            url: r.page.url,
            country: r.country.iso2,
            isp: nil,
            dns_ip: r.local_dns_ip,
            request_ip: r.proxied_ip,
            request_headers: nil,
            redirect_headers: nil,
            response_status: r.response_status,
            response_headers_time: nil,
            response_headers: r.response_headers,
            response_content_time: r.response_time,
            response_content: nil,
            created: r.created_at
          },
          links: {
            'self' => "#{request.protocol}#{request.host}/laapi/requests/#{r.id}"
          }
        }

      }
    }
  end
end
