class SessionsController < ApplicationController
  skip_before_action :authorize

  def create
    case auth_hash['provider']
      when 'cronofy'
        process_cronofy(auth_hash)
        flash[:success] = "Connected to your calendars"
      when 'cronofy_service_account'
        process_cronofy_service_account(auth_hash)
        flash.now[:success] = "Connected to your calendars"

        redirect_to enterprise_connect_index_path and return
      else
        flash[:error] = "Unrecognised provider login"
    end

    redirect_to root_path
  end

  def failure
    case params[:strategy]
      when "cronofy"
        flash[:alert] = "Unable to connect to your calendars: #{params[:message]}"
      else
        flash[:error] = "Failure from unrecognised provider"
    end
    redirect_to :root
  end

  def destroy
    logout
    flash.now[:info] = "Logged out"
    redirect_to :root
  end

  protected
  def auth_hash
    request.env['omniauth.auth']
  end

  def process_cronofy(auth_hash)
    user = User.find_or_create_by(cronofy_id: auth_hash["uid"])

    user.email = auth_hash['info']['email']
    user.name = auth_hash['info']['name']
    user.timezone = auth_hash['info']['default_tzid']

    user.cronofy_access_token = auth_hash['credentials']['token']
    user.cronofy_refresh_token = auth_hash['credentials']['refresh_token']
    user.cronofy_access_token_expiration = Time.at(auth_hash['credentials']['expires_at'])

    user.save

    login(user)
  end

  def process_cronofy_service_account(auth_hash)
    organization = Organization.find_or_create_by(cronofy_account_id: auth_hash['uid'])
    organization.cronofy_account_id = auth_hash['uid']
    organization.cronofy_access_token = auth_hash['credentials']['token']
    organization.cronofy_refresh_token = auth_hash['credentials']['refresh_token']
    organization.cronofy_access_token_expiration = Time.at(auth_hash['credentials']['expires_at']).getutc
    organization.cronofy_domain = auth_hash['info']['domain']
    organization.save

    organization_login(organization)
  end
end
