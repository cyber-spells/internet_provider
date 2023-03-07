class Tariff < ApplicationRecord
  has_many :consumers

  has_many :payments, through: :consumers
end
