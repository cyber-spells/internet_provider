# frozen_string_literal: true

class PaymentComponent < ViewComponent::Base
  def initialize(payment:)
    @payment = payment
  end
end
