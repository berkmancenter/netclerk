class CountriesController < ApplicationController
  def index
    @countries = Country.all
  end

  def show
    @country = Country.find(params[:id])

    @statuses = Status.most_recent.where( country: @country ).group_by { |s| s.value }.sort_by { |sg| -sg[0] }
  end
end
