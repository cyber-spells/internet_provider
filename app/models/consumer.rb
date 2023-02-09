class Consumer < ApplicationRecord
  belongs_to :tariff

  scope :soon_expirats, -> {where("tariff_expiration_at > ? and tariff_expiration_at <= ?",Date.current, Date.current + 5.days)}

  def try_renew_tariff
    self.balance -= tariff.price
    return unless balance >= 0
    self.tariff_expiration_at = Date.current()+ tariff.expiration_days.days
    save
  end

  def active
     Date.current()<tariff_expiration_at
  end
end
