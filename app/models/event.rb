class Event
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :calendar_id,
                :summary,
                :description,
                :start_time,
                :end_time

  validates :calendar_id, presence: true
  validates :summary, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :end_time_is_not_before_start_time

  def end_time_is_not_before_start_time
    if start_time > end_time
      errors.add(:end_time, "can't be before the start time")
    end
  end
end