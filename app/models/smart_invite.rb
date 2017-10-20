class SmartInvite < ApplicationRecord

  attr_accessor :callback_url
  attr_accessor :summary
  attr_accessor :description
  attr_accessor :event_start
  attr_accessor :event_end
  attr_accessor :location_description
  attr_accessor :location_lat
  attr_accessor :location_long

  validates :smart_invite_id, presence: true
  validates :callback_url, presence: true
  validates :email, presence: true
  validates :summary, presence: true

  validate :times_are_present
  validate :end_time_is_not_before_start_time if :times_are_present?

  with_options if: :geo_location_present? do |event|
    event.validates :location_lat, numericality: { greater_than_or_equal_to: -85.05115, less_than_or_equal_to: 85.05115 }
    event.validates :location_long, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  end

  def times_are_present
    unless times_are_present?
      if event_start.empty?
        errors.add(:start_time, "must be present")
      end

      if event_end.empty?
        errors.add(:end_time, "must be present")
      end
    end
  end

  def times_are_present?
    !event_start.empty? and !event_end.empty?
  end

  def end_time_is_not_before_start_time
    return unless times_are_present?

    if start_time > end_time
      errors.add(:end_time, "can't be before the start time")
    end
  end

def geo_location_present?
    location_lat.present? and location_long.present?
  end

  def start_time
    Time.parse(event_start)
  end

  def end_time
    Time.parse(event_end)
  end

  def data
    event = {
      summary: summary,
      description: description,
      start: start_time,
      end: end_time,
      tzid: 'Etc/UTC'
    }

    event[:location] = { description: location_description } if location_description

    if geo_location_present?
      event[:location] ||= {}

      event[:location][:lat] = location_lat
      event[:location][:long] = location_long
    end

    {
      smart_invite_id: smart_invite_id,
      callback_url: callback_url,
      recipient: {
        email: email,
      },
      event: event
    }
  end

  def is_number?(val)
    /\A[-+]?[0-9]*\.?[0-9]+\Z/ =~ val
  end
end
