class Availability
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :account_id_1,
                :account_id_2,
                :required_participants,
                :duration,
                :start_time,
                :end_time,
                :invalid_request_error

  validates :account_id_1, presence: true
  validates :account_id_2, presence: true
  validate :account_ids_differ
  validates :required_participants, inclusion: { in: %w{1 all}, message: "must be 1 or all" }
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validate :dates

  def account_ids_differ
    errors.add(:account_id_2, "must be different to Account ID 1") if account_id_1 == account_id_2
  end

  def dates
    if start_time.empty?
      errors.add(:start_time, "must be set")

      return
    end

    if end_time.empty?
      errors.add(:end_time, "must be set")

      return
    end

    start_time_d = DateTime.parse(start_time)
    end_time_d = DateTime.parse(end_time)

    if start_time_d < Date.current
      errors.add(:start_time, "must be in the future")
    end

    if start_time_d > Date.current + 35.days
      errors.add(:start_time, "must be within 35 days of today")
    end

    if end_time_d < start_time_d
      errors.add(:end_time, "must be after start time")
    end

    if end_time_d > (start_time_d + 1.day + 1.minute)
      errors.add(:end_time, "must be within 1 day and 1 minute of start time")
    end
  end

  def data
    {
        participants: {
            members: [{
                sub: account_id_1,
            },{
                sub: account_id_2,
            }],
            required: required_participants,
        },
        required_duration: duration,
        available_periods: [{
            start: start_time,
            end: end_time
        }]
    }
  end
end
