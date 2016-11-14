class Calendar
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :profile_id,
                :name

  validates :profile_id, presence: true
  validates :name, presence: true

  def data
    {
        profile_id: profile_id,
        name: name
    }
  end
end
