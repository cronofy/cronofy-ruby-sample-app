class CalendarsController < ApplicationController
  def show
    @calendar = calendar_by_id(params[:id])
    @events = cronofy.read_events(params[:id])
  end

  def new
    @account_profile = cronofy.list_profiles.find { |profile| profile.profile_id == params[:id] }
  end

  def create
  end
end
