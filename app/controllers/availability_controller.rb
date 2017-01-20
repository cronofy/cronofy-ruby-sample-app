class AvailabilityController < ApplicationController
  skip_before_action :authorize, only: [:account_id]

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
