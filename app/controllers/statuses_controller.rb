class StatusesController < ApplicationController
  def index
    @statuses = Status.order 'created_at desc'
  end

  def show
    @status = Status.find(params[:id])
    @statuses = Status.where( country: @status.country, page: @status.page ).order( 'created_at desc' )
  end
end
