class ServiceAccountUserEventsController < ServiceAccountBaseController
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

    redirect_to service_account_user_calendar_path(service_account_user_id: params[:service_account_user_id], id: @event.calendar_id)
  end
end