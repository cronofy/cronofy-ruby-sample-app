class FreeBusyController < ApplicationController
  def index
    @free_busy = cronofy.free_busy
  end
end