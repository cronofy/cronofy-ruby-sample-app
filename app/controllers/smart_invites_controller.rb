class SmartInvitesController < ApplicationController
  before_action :verify_external_domain!

  def index
    @invites = SmartInvite.all
  end

  def new
    @invite = SmartInvite.new
    @invite.event_start = Time.now + 30.minutes
    @invite.event_end = Time.now + 60.minutes
  end

  def create
    @invite = SmartInvite.new(params[:smart_invite].permit!)
    @invite.callback_url = "#{ENV['DOMAIN']}#{push_smart_invite_path}"

    unless @invite.valid?
      logger.info { "#{@invite.inspect}" }
      render :new and return
    end

    response = cronofy.upsert_smart_invite(@invite)
    @invite.save

    logger.info { "Invite created - #{response.smart_invite_id}" }
    SmartInviteMailer.invite(response).deliver_now

    redirect_to smart_invites_path
  end

  def show
    @invite = cronofy.get_smart_invite(params[:id], params[:email])
  end
end
