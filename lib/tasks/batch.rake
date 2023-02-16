namespace :batch do
  desc "TODO"
  task update_consumer_balance: :environment do
    Consumer.all.each do |consumer|
      amount = consumer.tariff.price / consumer.tariff.expiration_days.to_f
      new_balance = consumer.balance - amount

      # if new_balance is less than 0.0, we do not change balance, and change tariff_expiration_at to current_day
      if new_balance < 0.0
        consumer.update(tariff_expiration_at: Date.current)
      else
        consumer.update(balance: new_balance.round(2))
        consumer.update(tariff_expiration_at: (Date.current + (consumer.balance / (consumer.tariff.price / consumer.tariff.expiration_days.to_f)).to_f))
      end
    end
  end

  task processing_change_tariff_requests: :environment do
    ChangeTariffRequest.all.where(processed: false).each do |change_tariff_request|
      consumer = change_tariff_request.consumer

      # change tariff for consumer
      consumer.update(tariff_id: change_tariff_request.tariff.id)

      # recalculate tariff_expiration_at for current tariff
      consumer.update(tariff_expiration_at: (Date.current + (consumer.balance / (consumer.tariff.price / consumer.tariff.expiration_days.to_f)).to_f))

      change_tariff_request.update(processed: true)
    end
  end
end
