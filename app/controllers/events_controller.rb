class EventsController < ApplicationController
  def show

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

    redirect_to calendar_path(id: @event.calendar_id)
  end
end