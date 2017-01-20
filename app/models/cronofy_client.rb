class CronofyClient
  class CredentialsInvalidError < RuntimeError
  end

  def initialize(user)
    if user
      Rails.logger.info { "Cronofy client initialized - user.id=#{user.id} - access_token=#{user.cronofy_access_token} - refresh_token=#{user.cronofy_refresh_token}" }
      @user = user
    else
      Rails.logger.info { "Cronofy client initialized - no user" }
    end
  end

  def account
    Rails.logger.info { "Cronofy request - account" }
    response = cronofy_request { cronofy.account }
    Rails.logger.info { "Cronofy response - account - #{response.inspect}" }
    response
  end

  def get_token_from_code(code, redirect_url)
    Rails.logger.info { "Cronofy request - get_token_from_code" }
    response = cronofy_request { cronofy.get_token_from_code(code, redirect_url) }
    Rails.logger.info { "Cronofy response - get_token_from_code - #{response.inspect}" }
    response
  end

  def user_auth_link(redirect_url, options)
    Rails.logger.info { "Cronofy request - user_auth_link" }
    response = cronofy_request { cronofy.user_auth_link(redirect_url, options) }
    Rails.logger.info { "Cronofy response - user_auth_link - #{response.inspect}" }
    response
  end

  def list_calendars
    Rails.logger.info { "Cronofy request - list_calendars" }
    response = cronofy_request { cronofy.list_calendars }
    Rails.logger.info { "Cronofy response - list_calendars - #{response.inspect}" }
    response
  end

  def read_events(calendar_id)
    Rails.logger.info { "Cronofy request - read_events - calendar_id=#{calendar_id}" }
    response = cronofy_request { cronofy.read_events(include_managed: true, calendar_ids: [calendar_id]) }
    Rails.logger.info { "Cronofy response - read_events - #{response.inspect}" }
    response
  end

  def upsert_event(event)
    Rails.logger.info { "Cronofy request - upsert_event - event=#{event.inspect}" }
    response = cronofy_request { cronofy.upsert_event(event.calendar_id, event.data) }
    Rails.logger.info { "Cronofy response - upsert_event - #{response.inspect}" }
    response
  end

  def list_profiles
    Rails.logger.info { "Cronofy request - list_profiles" }
    response = cronofy_request { cronofy.list_profiles }
    Rails.logger.info { "Cronofy response - list_profiles - #{response.inspect}" }
    response
  end

  def create_calendar(calendar)
    Rails.logger.info { "Cronofy request - create_calendar - name=#{calendar.name} - profile_id=#{calendar.profile_id}" }
    response = cronofy_request { cronofy.create_calendar(calendar.profile_id, calendar.name) }
    Rails.logger.info { "Cronofy response - create_calendar - #{response.inspect}" }
    response
  end

  def delete_event(calendar_id, event_uid)
    Rails.logger.info { "Cronofy request - delete_event - calendar_id=#{calendar_id} - event_uid=#{event_uid}" }
    response = cronofy_request { cronofy.delete_event(calendar_id, event_uid) }
    Rails.logger.info { "Cronofy response - delete_event - #{response.inspect}" }
    response
  end

  def list_channels
    Rails.logger.info { "Cronofy request - list_channels" }
    response = cronofy_request { cronofy.list_channels }
    Rails.logger.info { "Cronofy response - list_channels - #{response.inspect}" }
    response
  end

  def create_channel(channel)
    Rails.logger.info { "Cronofy request - create_channel - url=#{ENV['DOMAIN'] + "/push/#{channel.path}" } - only_managed=#{channel.only_managed} - calendar_ids=#{channel.calendar_ids}" }
    response = cronofy_request { cronofy.create_channel(ENV['DOMAIN'] + "/push/#{channel.path}", filters: { only_managed: channel.only_managed, calendar_ids: channel.calendar_ids }) }
    Rails.logger.info { "Cronofy response - create_channel - #{response.inspect}" }
    response
  end

  def close_channel(channel_id)
    Rails.logger.info { "Cronofy request - close_channel - channel_id=#{channel_id}" }
    response = cronofy_request { cronofy.close_channel(channel_id) }
    Rails.logger.info { "Cronofy response - close_channel - #{response.inspect}" }
    response
  end

  def free_busy
    Rails.logger.info { "Cronofy request - free_busy" }
    response = cronofy_request { cronofy.free_busy }
    Rails.logger.info { "Cronofy response - free_busy - #{response.inspect}" }
    response
  end

  def resources
    Rails.logger.info { "Cronofy request - resources" }
    response = cronofy_request { cronofy.resources }
    Rails.logger.info { "Cronofy response - resources - #{response.inspect}" }
    response
  end

  def authorize_with_service_account(user, scopes, callback_url)
    Rails.logger.info { "Cronofy request - authorize_with_service_account - user.id=#{user.id} - scopes=#{scopes} - callback_url=#{callback_url}"}
    response = cronofy_request { cronofy.authorize_with_service_account(user.email, scopes, callback_url) }
    Rails.logger.info { "Cronofy response - authorize_with_service_account - #{response.inspect}" }
    response
  end

  private

  def cronofy
    @cronofy ||= Cronofy::Client.new(
        client_id: ENV['CRONOFY_CLIENT_ID'],
        client_secret: ENV['CRONOFY_CLIENT_SECRET'],
        access_token: @user ? @user.cronofy_access_token : "",
        refresh_token: @user ? @user.cronofy_refresh_token : ""
    )
  end

  def cronofy_request(&block)
    block.call
  rescue Cronofy::AuthorizationFailureError => e
    Rails.logger.warn "Error within cronofy_request - user.id=#{@user.id} - #{e.class} - #{e.message}"

    clear_cronofy_auth

    raise CredentialsInvalidError
  rescue Cronofy::AuthenticationFailureError => e
    Rails.logger.warn "Error within cronofy_request - user.id=#{@user.id} - #{e.class} - #{e.message}"

    begin
      credentials = cronofy.refresh_access_token
    rescue Cronofy::BadRequestError => e
      Rails.logger.warn "Error when refreshing access token - user.id=#{@user.id} - #{e.class} - #{e.message}"

      clear_cronofy_auth

      raise CredentialsInvalidError
    end

    @user.cronofy_access_token = credentials.access_token
    @user.cronofy_refresh_token = credentials.refresh_token
    @user.save

    Rails.logger.info "New Cronofy authentication details set - user.id=#{@user.id}"

    cronofy_request(&block)
  end

  def clear_cronofy_auth
    @user.cronofy_access_token = nil
    @user.cronofy_refresh_token = nil
    @user.save

    Rails.logger.info "Cronofy authentication details cleared - user.id=#{@user.id}"
  end
end