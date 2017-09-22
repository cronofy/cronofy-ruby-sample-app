OmniAuth.config.full_host = ENV['DOMAIN']

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :cronofy, ENV["CRONOFY_CLIENT_ID"], ENV["CRONOFY_CLIENT_SECRET"], {
      scope: "read_account list_calendars create_event delete_event create_calendar read_events",
      provider_ignores_state: true
  }

  provider :cronofy_service_account, ENV["CRONOFY_CLIENT_ID"], ENV["CRONOFY_CLIENT_SECRET"], {
      scope: "service_account/manage_accounts service_account/manage_resources",
      delegated_scope: "read_account list_calendars read_events create_event delete_event read_free_busy",
  }
end
