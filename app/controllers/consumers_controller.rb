class ConsumersController < ApplicationController
  before_action :authenticate_consumer!
  require 'liqpay'

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

  def refill
    @consumer = current_consumer

    liqpay = Liqpay.new

    liqpay.api('request', {
      action: 'pay',
      version: '3',
      amount: params[:amount],
      currency: 'UAH',
      order_id: @consumer.id.to_s + DateTime.now.to_i.to_s,
    })

    @html = liqpay.cnb_form({
                              action: "pay",
                              amount: params[:refill][:amount],
                              currency: "UAH",
                              description: "Поповнення рахунку користувача " + @consumer.username,
                              order_id: @consumer.id.to_s + DateTime.now.to_i.to_s,
                              version: "3",
                              result_url: root_url + "?successful_payment_form=true",
                              server_url: root_url + "consumers/#{@consumer.id}/update_balance",
                              language: 'uk',
                            }).html_safe
    respond_to do |format|
      format.html { render :refill }
      format.js { render :refill }
    end
  end

  def update_balance
    @consumer = current_consumer

    @consumer.update!(full_name: @consumer.full_name + "123")
    data = request.parameters['data']
    signature = request.parameters['signature']

    liqpay = Liqpay.new

    if liqpay.match?(data, signature)
      responce_hash = liqpay.decode_data(data)

      if responce_hash['status'] == 'success'
        @consumer.balance += responce_hash['amount'].to_f
        @consumer.full_name += ' ' + responce_hash.to_s
        # change consumer tariff_expiration_at

        @consumer.save

        # redirect_to consumer_path(@consumer)
      else
        # redirect_to consumer_path(@consumer)
      end
      # Check responce_hash['status'] and process due to Liqpay API documentation.
    else

      @consumer.save

      # redirect_to consumer_path(@consumer)
    end
  end
end
