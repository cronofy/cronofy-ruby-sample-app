class CronofyClient
  class CredentialsInvalidError < RuntimeError
  end

  def initialize(user)
    @user = user
  end

  def list_calendars
    cronofy_request { cronofy.list_calendars }
  end

  private

  def cronofy
    @cronofy ||= Cronofy::Client.new(
        client_id: ENV['CRONOFY_CLIENT_ID'],
        client_secret: ENV['CRONOFY_CLIENT_SECRET'],
        access_token: @user.cronofy_access_token,
        refresh_token: @user.cronofy_refresh_token
    )
  end

  def cronofy_request(&block)
    block.call
  rescue Cronofy::AuthorizationFailureError => e
    clear_cronofy_auth

    raise CredentialsInvalidError
  rescue Cronofy::AuthenticationFailureError => e
    begin
      credentials = cronofy.refresh_access_token
    rescue Cronofy::BadRequestError => e
      clear_cronofy_auth

      raise CredentialsInvalidError
    end

    @user.cronofy_access_token = credentials.access_token
    @user.cronofy_refresh_token = credentials.refresh_token
    @user.save

    cronofy_request(&block)
  end

  def clear_cronofy_auth
    @user.cronofy_access_token = nil
    @user.cronofy_refresh_token = nil
    @user.save
  end
end