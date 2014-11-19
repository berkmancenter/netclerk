class CountriesController < ApplicationController
  before_action :set_country, only: :show

  def index
    @countries = Country.all
  end

  def show
    @statuses = @country.statuses.group_by { |s| s.value }.sort_by { |sg| -sg[0] }
  end

  private

  def set_country
    @country = Country.find(params[:id])
  end
end
