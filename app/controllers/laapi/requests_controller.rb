class Laapi::RequestsController < ApplicationController
  protect_from_forgery with: :null_session

  def show
    response.headers[ 'Access-Control-Allow-Origin' ] = '*'

    api_data = map_requests [ Request.find(params[:id]) ]
      
    response.headers[ 'Content-Type' ] = 'application/vnd.api+json'
    render json: api_data[ :data ][ 0 ]
  end

  def create
    attributes = request_params[ :attributes ]

    url = attributes[ :url ]

    page = Page.find_by_url url

    request = Request.new( {
      page: page,
      country: Country.first
    } )

    render json: request_params, status: 200
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
