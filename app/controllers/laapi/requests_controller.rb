class Laapi::RequestsController < ApplicationController
  protect_from_forgery with: :null_session

  def show
    response.headers[ 'Access-Control-Allow-Origin' ] = '*'

    @request = Request.find(params[:id])

    response.headers[ 'Content-Type' ] = 'application/vnd.api+json'
    render json: @request.to_laapi
  end

  def create
    response.headers[ 'Access-Control-Allow-Origin' ] = '*'
    response.headers[ 'Content-Type' ] = 'application/vnd.api+json'

    Rails.logger.info params.inspect

    render json: { error: 500 }, status: 500
  end

  private

  def request_params
    params.require( :data ).permit( :type, :attributes => [ :url, :country, :isp, :dns_ip, :request_ip, :request_headers, :redirect_headers, :response_status, :response_headers_time, :response_headers, :response_content_time, :response_content ] )
  end
end
