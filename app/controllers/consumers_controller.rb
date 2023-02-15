class ConsumersController < ApplicationController
  before_action :authenticate_consumer!

  def show
    @consumer = current_consumer

    @tariff = @consumer.tariff

    @tariff_price_per_day = (@tariff.price / @tariff.expiration_days).round(2)

    @remaining_days = (@consumer.tariff_expiration_at - Date.today).to_i

    if @consumer.change_tariff_requests.any? && @consumer.change_tariff_requests.last.processed == false
      @change_tariff_request = @consumer.change_tariff_requests.last
    else
      @change_tariff_request = ChangeTariffRequest.new
    end
  end
end
