class EnterpriseConnectsController < ApplicationController
  skip_before_action :authorize, only: :service_account_auth_callback

  before_action :verify_external_domain!

  def show
    unless organization_logged_in?
      render :login and return
    end

    @resources = organization_cronofy.resources
    @users = User.where(cronofy_service_account_owner: current_organization.cronofy_account_id)
  end

  def new
    Rails.logger.debug "#{request.host}"
    @user = User.new
    @scope = 'read_account list_calendars read_events create_event delete_event read_free_busy'
  end

  def create
    @user = User.find_or_initialize_by({ email: params[:email], cronofy_service_account_owner: current_organization.cronofy_account_id })

    unless @user.valid?
      render :new and return
    end

    @user.save

    organization_cronofy.authorize_with_service_account(@user, params[:scope], auth_callback_url(@user))

    redirect_to enterprise_connect_path
  end

  def auth_callback_url(user)
    "#{external_domain}#{auth_callback_enterprise_connect_path(user_id: user.id)}"
  end

  def service_account_auth_callback
    user = User.find(params[:user_id])
    auth = params[:authorization]

    if auth[:code]
      logger.info ( "#service_account_auth_callback #{auth[:code]}" )

      cronofy = Cronofy::Client.new
      credentials = cronofy.get_token_from_code(auth[:code], request.url)

      user.cronofy_access_token = credentials.access_token
      user.cronofy_refresh_token = credentials.refresh_token
      user.cronofy_access_token_expiration = (Time.now + credentials.expires_in.seconds).getutc
      user.cronofy_is_service_account_token = true
      user.save

      cronofy = CronofyClient.new(user)
      channel = Channel.new({path: "service_account_user/#{user.id}", only_managed: false})
      cronofy.create_channel(channel)

      logger.info ( "#service_account_auth_callback updated credentials for user=#{user.id}" )

    elsif auth[:error]

      user.cronofy_service_account_error_key = auth[:error_key]
      user.cronofy_service_account_error_description = auth[:error_description]
      user.save

      logger.warn ( "#service_account_auth_callback error with credentials for user=#{user.id}" )

    else
      raise StandardError.new("Unexpected response payload auth=#{auth.inspect}")
    end

    render text: "OK", status: 200
  rescue => e
    logger.fatal("#service_account_auth_callback failed with #{e.message} with body=#{request.body}")
    render text: "Failed", status: 500
  end

  helper_method :user_status
  def user_status(user)
    unless user.cronofy_service_account_error_key.nil?
      "Failed"
    end
    if user.cronofy_access_token.nil?
      "Pending"
    else
      "Linked"
    end
  end
end