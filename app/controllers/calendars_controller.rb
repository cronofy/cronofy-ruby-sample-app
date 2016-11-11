class CalendarsController < ApplicationController
  def index
    @calendars = cronofy_client.list_calendars
  end

  def show
  end
end
