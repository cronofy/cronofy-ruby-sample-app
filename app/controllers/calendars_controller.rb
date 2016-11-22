class CalendarsController < ApplicationController
  def show
    @calendar = calendar_by_id(params[:id])
    @events = cronofy.read_events(params[:id])
  end

  def new
    @account_profile = cronofy.list_profiles.find { |profile| profile.profile_id == params[:profile_id] }

    @calendar = Calendar.new
    @calendar.profile_id = params[:profile_id]
  end

  def create
    @calendar = Calendar.new(params[:calendar].permit!)

    unless @calendar.valid?
      @account_profile = cronofy.list_profiles.find { |profile| profile.profile_id == params[:profile_id] }
      render :new and return
    end

    cronofy.create_calendar(@calendar)

    logger.info { "Calendar created - name=#{@calendar.name} - profile.id = #{params[:profile_id]}"}

    redirect_to profiles_path
  end
end
