Rails.application.config.middleware.use OmniAuth::Builder do
  provider :cronofy, ENV["CRONOFY_CLIENT_ID"], ENV["CRONOFY_CLIENT_SECRET"], {
      scope: "read_account list_calendars create_event delete_event create_calendar read_events"
  }

  provider :cronofy_service_account, ENV["CRONOFY_CLIENT_ID"], ENV["CRONOFY_CLIENT_SECRET"], {
      scope: "service_account/manage_accounts service_account/manage_resources",
      delegated_scope: "read_account read_events create_event delete_event event_reminders",
  }
end
