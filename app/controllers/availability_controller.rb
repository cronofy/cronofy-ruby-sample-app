class AvailabilityController < ApplicationController
  skip_before_action :authorize, only: [:account_id]

  def index
    @availability = Availability.new(duration: '60')
    @auth_url = auth_url
  end

  def view
    @availability = Availability.new(params[:availability].permit!)

    unless @availability.valid?
      render :index and return
    end

    @available_periods = cronofy.availability({
        participants: [{
            members: [{
                sub: @availability.account_id_1,
            },{
                sub: @availability.account_id_2,
            }],
            required: @availability.required_participants,
        }],
        required_duration: {
            minutes: @availability.duration
        },
        available_periods: [{
            start: @availability.start_time.to_time,
            end: @availability.end_time.to_time,
        }]
    })

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
