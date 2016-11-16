class Channel < ApplicationRecord
  attr_accessor :only_managed,
                :calendar_ids

  validates :path, presence: true
end
