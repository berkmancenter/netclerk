class StatusesController < ApplicationController
  def index
    @changed = NewestStatusFinder.changed
    @statuses = NewestStatusFinder.random(50)
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
