class CalendarsController < ApplicationController
  def index
    @calendars = cronofy.list_calendars
  end

  def show
    @calendar = calendar_by_id(params[:id])
    @events = cronofy.read_events(params[:id])
  end
end
