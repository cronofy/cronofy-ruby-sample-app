class EnterpriseConnectUser
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :email,
                :scope,
                :callback_url

  validates :email, presence: true
  validates :scope, presence: true
  validates :callback_url, presence: true
end