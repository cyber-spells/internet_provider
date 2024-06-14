require 'prawn'

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
        pdf = Prawn::Document.new

        # Use Google Font directly (Roboto in this case)
        pdf.font_families.update(
          "Roboto" => {
            normal: Rails.root.join("app/assets/fonts/Roboto-Regular.ttf"),
            italic: Rails.root.join("app/assets/fonts/Roboto-Italic.ttf"),
            bold: Rails.root.join("app/assets/fonts/Roboto-Bold.ttf"),
            bold_italic: Rails.root.join("app/assets/fonts/Roboto-BoldItalic.ttf")
          }
        )

        pdf.font("Roboto") # Set the default font to Roboto

        # Title with similar style as <h1>
        pdf.text "SunCom", size: 24, style: :bold, align: :center
        pdf.move_down 10

        # Title with similar style as <h3 class="mb-3">
        pdf.text @payment.title, size: 18, style: :bold, align: :center
        pdf.move_down 10

        # Similar style as <p>
        pdf.text "Сума: ", size: 12, style: :normal
        pdf.text @payment.sum.to_s, size: 12, style: :italic
        pdf.move_down 5

        pdf.text "Тариф: ", size: 12, style: :normal
        pdf.text @payment.tariff.name, size: 12, style: :italic
        pdf.move_down 5

        # Similar style as <p class="text-muted">
        pdf.text "Створено: #{l(@payment.created_at, format: :long)}", size: 10, style: :italic, color: "666666"

        send_data pdf.render, filename: 'payment.pdf', type: 'application/pdf', disposition: 'attachment'
      end
    end
  end
end
