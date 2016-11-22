class CronofyClient
  class CredentialsInvalidError < RuntimeError
  end

  def initialize(user)
    @user = user
  end

  def account
    cronofy_request { cronofy.list_profiles }
  end

  def list_calendars
    cronofy_request { cronofy.list_calendars }
  end

  def read_all_events
    cronofy_request { cronofy.read_events(include_managed: true) }
  end

  def read_events(calendar_id)
    cronofy_request { cronofy.read_events(include_managed: true, calendar_ids: [calendar_id]) }
  end

  def upsert_event(event)
    cronofy_request { cronofy.upsert_event(event.calendar_id, event.data) }
  end

  def list_profiles
    cronofy_request { cronofy.list_profiles }
  end

  def create_calendar(calendar)
    cronofy_request { cronofy.create_calendar(calendar.profile_id, calendar.name) }
  end

  def delete_event(calendar_id, event_uid)
    cronofy_request { cronofy.delete_event(calendar_id, event_uid) }
  end

  def list_channels
    cronofy_request { cronofy.list_channels }
  end

  def create_channel(channel)
    cronofy_request { cronofy.create_channel(ENV['DOMAIN'] + "/push/#{channel.path}", filters: { only_managed: channel.only_managed, calendar_ids: channel.calendar_ids }) }
  end

  def close_channel(channel_id)
    cronofy_request { cronofy.close_channel(channel_id) }
  end

  def free_busy
    cronofy_request { cronofy.free_busy }
  end

  def resources
    cronofy_request { cronofy.resources }
  end

  def authorize_with_service_account(user, scopes, callback_url)
    cronofy_request { cronofy.authorize_with_service_account(user.email, scopes, callback_url) }
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