class ServiceAccountBaseController < ApplicationController
  before_action :set_cronofy_instance

  helper_method :user

  def user
    @user = User.find(params[:service_account_user_id] || params[:id])
  end

  def set_cronofy_instance
    @cronofy = CronofyClient.new(user)
  end
end