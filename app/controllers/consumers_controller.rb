class ConsumersController < ApplicationController
  before_action :authenticate_consumer!

  def show
    @consumer = current_consumer

    @tariff = @consumer.tariff

    @tariff_price_per_day = (@tariff.price / @tariff.expiration_days.to_f).round(2)

    @remaining_days = get_remaining_days(@consumer)

    if @consumer.change_tariff_requests.any? && @consumer.change_tariff_requests.last.processed == false
      @change_tariff_request = @consumer.change_tariff_requests.last
    else
      @change_tariff_request = ChangeTariffRequest.new
    end
  end

  def refill
    @consumer = current_consumer
    @amount = params[:refill][:amount]

    respond_to do |format|
      format.html { render :refill }
      format.js { render :refill }
    end
  end

  def update_balance
    @consumer = current_consumer
    @amount = params[:amount]
    if params[:status] == "success"
      @consumer.balance += @amount.to_i

      @consumer.tariff_expiration_at = Date.current + (@consumer.balance / (@consumer.tariff.price / @consumer.tariff.expiration_days.to_f)).to_f
      if @consumer.save
        respond_to do |format|
          format.json { render json: { new_balance: @consumer.balance, remaining_days: get_remaining_days(@consumer) } }
        end
      end
    end
  end

  private

  def get_remaining_days(consumer)
    (consumer.tariff_expiration_at - Date.today).to_i
  end
end
