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
                :end_time

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
