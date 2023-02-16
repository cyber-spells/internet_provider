ActiveAdmin.register ChangeTariffRequest do
  permit_params :consumer_id, :tariff_id, :processed

  index do
    selectable_column
    id_column
    column :consumer
    column :tariff
    column :processed
    actions
  end

  filter :processed

  form do |f|
    f.inputs "Change Tariff Request Details" do
      f.input :consumer
      f.input :tariff
      f.input :processed
    end
    f.actions
  end

  show do
    attributes_table do
      row :consumer
      row :tariff
      row :processed
    end
  end

  controller do
    def update
      @change_tariff_request = ChangeTariffRequest.find(params[:id])

      if @change_tariff_request.update(change_tariff_request_params)
        if @change_tariff_request.processed
          consumer = @change_tariff_request.consumer

          # change tariff for consumer
          consumer.update(tariff_id: @change_tariff_request.tariff.id)

          # recalculate tariff_expiration_at for current tariff
          consumer.update(tariff_expiration_at: (Date.current + (consumer.balance / (consumer.tariff.price / consumer.tariff.expiration_days.to_f)).to_f))

        end
        redirect_to admin_change_tariff_requests_path, notice: 'Change tariff_request was updated'
      end
    end

    private

    def change_tariff_request_params
      params.require(:change_tariff_request).permit(:consumer_id, :tariff_id, :processed)
    end
  end
end
