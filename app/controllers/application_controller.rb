class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  before_action :authorize

  def login(user)
    session[:user_id] = user.id
  end

  def logout
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def cronofy
    @cronofy ||= CronofyClient.new(current_user)
  end

  def calendar_by_id(calendar_id)
    cronofy.list_calendars.find { |calendar| calendar.calendar_id == calendar_id }
  end

  private

  def authorize
    unless logged_in?
      redirect_to root_path
    end
  end
end
