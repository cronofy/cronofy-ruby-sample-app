class PushController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  skip_before_action :authorize

  def call
    channel = Channel.find { |channel| channel.path == params[:path] }

    unless channel.nil?
      channel.last_body = "type: #{params[:notification][:type]}\nchanges_since: #{params[:notification][:changes_since]}\n\n" + channel.last_body.to_s
      channel.last_called = Time.now
      channel.save
    end
  end
end