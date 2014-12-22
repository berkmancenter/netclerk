class PagesController < ApplicationController
  before_action :set_page, only: :show

  def index
    @pages = Page.order( 'RANDOM()' ).limit( 50 )
  end

  def show
    @statuses = NewestStatusFinder.per_country_for_page(@page)
      .group_by { |s| s.value }
      .sort_by { |sg| -sg[0] }
  end

  def new
    @page = Page.new
  end

  private

  def set_page
    @page = Page.find(params[:id])
  end
end
