class EventsController < ApplicationController
  def show
    @calendar = calendar_by_id(params[:calendar_id])
    @event = cronofy.read_events(params[:calendar_id]).find { |event| event.event_uid == params[:id] }
  end

  def new
    @calendar = calendar_by_id(params[:calendar_id])

    @event = Event.new
    @event.calendar_id = params[:calendar_id]
    @event.event_id = "unique_event_id_" + rand(10000000).to_s
  end

  def create
    @event = Event.new(params[:event].permit!)

    unless @event.valid?
      @calendar = calendar_by_id(@event.calendar_id)
      render :new and return
    end

    cronofy.upsert_event(@event)

    redirect_to profile_calendar_path(profile_id: params[:profile_id], id: @event.calendar_id)
  end

  def destroy
    cronofy.delete_event(params[:calendar_id], params[:event_id])

    redirect_to profile_calendar_path(profile_id: params[:profile_id], id: params[:calendar_id])
  end
end