class EnterpriseConnectController < ApplicationController
  def index
    unless organization_logged_in?
      render :login and return
    end

    @resources = organization_cronofy.resources
  end
end