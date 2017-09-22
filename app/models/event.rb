class Event
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :calendar_id,
                :event_id,
                :event_uid,
                :summary,
                :description,
                :event_start,
                :event_end,
                :location_description,
                :location_lat,
                :location_long

  validates :calendar_id, presence: true
  validates :event_id, presence: true
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
    !location_lat.blank? or !location_long.blank?
  end

  def start_time
    Time.parse(event_start)
  end

  def end_time
    Time.parse(event_end)
  end

  def data
    event = {
        event_id: event_id,
        summary: summary,
        description: description,
        start: start_time,
        end: end_time
    }

    event[:location] = { description: location_description } if location_description

    unless geo_location_present?
      event[:location] = {} if event[:location].nil?

      event[:location][:lat] = location_lat
      event[:location][:long] = location_long
    end

    event
  end

  def is_number?(val)
    /\A[-+]?[0-9]*\.?[0-9]+\Z/ =~ val
  end
end