class PagesController < ApplicationController
  def index
    @pages = Page.all
  end

  def show
    @page = Page.find(params[:id])
    @statuses = Status.most_recent.where( page: @page ).group_by { |status| status.value }
  end

  def new
    @page = Page.new
  end
end
