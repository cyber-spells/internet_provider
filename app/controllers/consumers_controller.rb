class ConsumersController < ApplicationController
  before_action :authenticate_consumer!

  def show
    @consumer = current_consumer

    @tariff = @consumer.tariff

    @tariff_price_per_day = (@tariff.price / @tariff.expiration_days).round(2)
  end
end
