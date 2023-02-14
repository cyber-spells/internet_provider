class ConsumersController < ApplicationController
  before_action :authenticate_consumer!

  def show
    @consumer = Consumer.find(params[:id])
  end
end
