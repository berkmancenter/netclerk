class StatusesController < ApplicationController
  def index
    @statuses = Status.where( "created_at >= '#{Date.today.to_s}'" ).order( 'RANDOM()' ).limit( 50 )
  end

  def show
    @status = Status.find(params[:id])
    @statuses = Status.where( country: @status.country, page: @status.page ).order( 'created_at desc' )
  end
end
