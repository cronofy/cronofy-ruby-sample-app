class CalendarsController < ApplicationController
  def index
    cronofy = CronofyClient.new(current_user)

    @calendars = cronofy.list_calendars
  end

  def show
  end
end
