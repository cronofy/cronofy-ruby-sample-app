class EnterpriseConnectController < ApplicationController
  def index
    unless organization_logged_in?
      render :login and return
    end

    @resources = organization_cronofy.resources
  end

  def new
    @user = EnterpriseConnectUser.new
    @user.scope = 'read_account list_calendars read_events create_event delete_event read_free_busy'
  end

  def create
    @user = EnterpriseConnectUser.new(params[:enterprise_connect_user].permit!)

    unless @user.valid?
      render :new and return
    end

    organization_cronofy.authorize_with_service_account(@user)

    redirect_to enterprise_connect_index_path
  end
end