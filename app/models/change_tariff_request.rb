class ChangeTariffRequest < ApplicationRecord
  belongs_to :consumer
  belongs_to :tariff

  enum state: {
    pending: 0,
    accepted: 1,
    rejected: 2
  }
end
