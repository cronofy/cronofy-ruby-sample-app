class RootController < ApplicationController
  skip_before_action :authorize

  def show
  end
end