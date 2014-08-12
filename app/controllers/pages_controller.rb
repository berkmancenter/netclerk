class PagesController < ApplicationController
  def index
    @pages = Page.order( 'RANDOM()' ).limit( 20 )
  end

  def show
    @page = Page.find(params[:id])
    @statuses = Status.most_recent.where( page: @page ).group_by { |s| s.value }.sort_by { |sg| -sg[0] }
  end

  def new
    @page = Page.new
  end
end
