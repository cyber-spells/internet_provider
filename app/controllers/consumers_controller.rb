class ConsumersController < ApplicationController
  before_action :authenticate_consumer!

  def show
    @consumer = current_consumer
  end
end
