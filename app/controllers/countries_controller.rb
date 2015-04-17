class CountriesController < ApplicationController
  before_action :set_country, only: :show

  def index
    @countries = Country.all
  end

  def show
    @statuses = @country.statuses.includes(:page).select(
      'distinct on (page_id) *'
    ).order(
      page_id: :asc, created_at: :desc
    ).group_by { |s| s.value }.sort_by { |sg| -sg[0] }
  end

  private

  def set_country
    @country = Country.find(params[:id])
  end
end
