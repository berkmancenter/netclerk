class JsonapiController < ApplicationController
  def index
    response.headers[ 'Access-Control-Allow-Origin' ] = '*'
    @statuses = NewestStatusFinder.changed

    api_data = {
      data: @statuses.map { |s|
        {
          type: 'statuses',
          id: s.id.to_s,
          attributes: {
          }
        }

      }
    }

    render json: api_data
  end
end
