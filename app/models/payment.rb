class Payment < ApplicationRecord
  belongs_to :consumer
  belongs_to :tariff

end
