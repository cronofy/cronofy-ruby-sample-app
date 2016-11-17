class RootController < ApplicationController
  skip_before_action :authorize

  def show
    unless ENV['CRONOFY_CLIENT_ID'] and ENV['CRONOFY_CLIENT_SECRET']
      render :no_credentials and return
    end

    unless logged_in?
      render :login and return
    end
  end
end