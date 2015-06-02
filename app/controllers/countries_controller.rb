class CountriesController < ApplicationController
  before_action :set_country, only: :show

  def index
    @cache_key = Status.order(created_at: :desc).first.try(:created_at).try(:to_i)
    @countries = Country.has_statuses
  end

  def show
    @cache_key = @country.statuses.order(created_at: :desc).first.try(:created_at).try(:to_i)
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
