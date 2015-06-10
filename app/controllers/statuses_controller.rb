class StatusesController < ApplicationController
  def index
    @statuses = NewestStatusFinder.changed
  end

  def show
    @status = Status.find(params[:id])
    @previous_statuses =
      PreviousStatusFinder.statuses(
        @status.created_at,
        @status.country_id,
        @status.page_id,
        5,
      )
  end
end
