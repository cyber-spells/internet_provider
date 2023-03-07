class PaymentsController < ApplicationController
  def get_payment
    @payment = Payment.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def download_payment
    @payment = Payment.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "payment",
               template: "payments/_payment_receipt.html.erb",
               locals: { payment: @payment },
               disposition: "attachment",
               encoding: "UTF-8"
      end
    end
  end
end
