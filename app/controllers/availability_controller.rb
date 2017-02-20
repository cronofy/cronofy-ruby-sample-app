class AvailabilityController < ApplicationController
  skip_before_action :authorize, only: [:account_id]

  def index
    @availability = Availability.new(
        account_id_1: cronofy.account.account_id,
        duration: '60',
        start_time: (DateTime.current + 1.day).strftime("%Y-%m-%dT00:00"),
        end_time: (DateTime.current + 2.days).strftime("%Y-%m-%dT00:00"),
    )
    @auth_url = auth_url
  end

  def view
    @availability = Availability.new(params[:availability].permit!)

    unless @availability.valid?
      render :index and return
    end

    @available_periods = cronofy.availability(@availability.data)

    @call_made = true

    render :index
  rescue Cronofy::InvalidRequestError => e
    @availability.invalid_request_error = JSON.parse(e.body)

    render :index
  end

  def account_id
    credentials = cronofy.get_token_from_code(params[:code], redirect_url)

    @account_id = credentials.account_id
    @auth_url = auth_url
  rescue
    redirect_to auth_url
  end

  private

  def auth_url
    cronofy.user_auth_link(redirect_url, { scope: ["read_account", "read_events", "read_free_busy"] })
  end

  def redirect_url
    "#{ENV['DOMAIN']}/availability/account_id"
  end
end
