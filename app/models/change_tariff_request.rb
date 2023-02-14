class ChangeTariffRequest < ApplicationRecord
  belongs_to :consumer
  belongs_to :tariff
end
