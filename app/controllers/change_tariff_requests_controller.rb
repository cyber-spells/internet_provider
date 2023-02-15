class ChangeTariffRequestsController < ApplicationController
  def create
    @change_tariff_request = ChangeTariffRequest.new(change_tariff_request_params)

    respond_to do |format|
      if @change_tariff_request.save!
        format.js { render :create }
        # TODO: Add success handling for JS
      else
        format.html { render root_path }
        # TODO: Add error handling for JS
      end
    end
  end

  private

  def change_tariff_request_params
    params.require(:change_tariff_request).permit(:consumer_id, :tariff_id)
  end
end
