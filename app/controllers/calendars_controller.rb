class CalendarsController < ApplicationController
  def index
    cronofy = CronofyClient.new(current_user)

    @calendars = cronofy.list_calendars
  end

  def show
    cronofy = CronofyClient.new(current_user)

    @calendar = cronofy.list_calendars.find { |calendar| calendar.calendar_id == params[:id] }
    @events = cronofy.read_events(params[:id])
  end
end
