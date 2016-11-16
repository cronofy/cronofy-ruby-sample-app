class Channel
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :channel_id,
                :only_managed,
                :calendar_ids

  validates :channel_id, presence: true
end
