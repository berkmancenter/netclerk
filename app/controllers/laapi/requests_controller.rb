class Laapi::RequestsController < ApplicationController
  protect_from_forgery with: :null_session

  def show
    response.headers[ 'Access-Control-Allow-Origin' ] = '*'

    api_data = map_requests [ Request.find(params[:id]) ]
      
    response.headers[ 'Content-Type' ] = 'application/vnd.api+json'
    render json: api_data[ :data ][ 0 ]
  end

  def create
    response.headers[ 'Content-Type' ] = 'application/vnd.api+json'

    attributes = request_params[ :attributes ]

    url = attributes[ :url ]
    page = Page.find_or_create_by url: url

    request = Request.new( {
      page: page,
      country: Country.find_by( iso2: 'US' ),
      unproxied_ip: nil, # request locally
      proxied_ip: attributes[ :request_ip ],
      local_dns_ip: attributes[ :dns_ip ],
      response_time: attributes[ :response_content_time ],
      response_status: attributes[ :response_status ],
      response_headers: attributes[ :response_headers ],
      response_length: nil, # extract from header
      response_delta: 0 # compare to baseline_content
    } )

    if request.save
      api_data = map_requests [ request ]

      render json: api_data[ :data ][ 0 ]
    else
      render json: { error: 500 }, status: 500
    end
  end

  private

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

  def request_params
    params.require( :data ).permit( :type, :attributes => [ :url, :country, :isp, :dns_ip, :request_ip, :request_headers, :redirect_headers, :response_status, :response_headers_time, :response_headers, :response_content_time, :response_content ] )
  end
end
