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

      @event.event_start = @event.start_time.to_time
      @event.event_end = @event.end_time.to_time

      render :new and return
    end

    cronofy.upsert_event(@event)

    redirect_to profile_calendar_path(profile_id: params[:profile_id], id: @event.calendar_id)
  end

  def destroy
    cronofy.delete_event(params[:calendar_id], params[:id])

    redirect_to profile_calendar_path(profile_id: params[:profile_id], id: params[:calendar_id])
  end

  def edit
    @calendar = calendar_by_id(params[:calendar_id])

    event = cronofy.read_events(params[:calendar_id]).find { |event| event.event_uid == params[:id] }

    @event = Event.new({
                           event_id: event.event_id,
                           event_uid: event.event_uid,
                           calendar_id: params[:calendar_id],
                           summary: event.summary,
                           description: event.description,
                           event_start: event.start.to_time,
                           event_end: event.end.to_time
                       })

    if event.location
      @event.location_lat = event.location.lat
      @event.location_long = event.location.long
    end
  end

  def update
    @event = Event.new(params[:event].permit!)

    unless @event.valid?
      @calendar = calendar_by_id(@event.calendar_id)
      render :edit and return
    end

    cronofy.upsert_event(@event)

    redirect_to profile_calendar_event_path(profile_id: params[:profile_id], calendar_id: @event.calendar_id, id: @event.event_uid)
  end
end