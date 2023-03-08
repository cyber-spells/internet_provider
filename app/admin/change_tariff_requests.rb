ActiveAdmin.register ChangeTariffRequest do
  permit_params :consumer_id, :tariff_id, :processed, :state, :comment

  index do
    selectable_column
    id_column
    column :consumer
    column :tariff
    column :processed
    column :state do |model|
      t("state.#{model.state}")
    end
    column :comment
    actions
  end

  filter :processed

  form do |f|
    f.inputs "Change Tariff Request Details" do
      f.input :consumer
      f.input :tariff
      f.input :processed
      f.input :state, as: :select, collection: ChangeTariffRequest.states.keys.map { |u| ["#{t("state.#{u}")}", u] }
      f.input :comment
    end
    f.actions
  end

  show do
    attributes_table do
      row :consumer
      row :tariff
      row :processed
      row :state
      row :comment
    end
  end

  controller do
    def update
      @change_tariff_request = ChangeTariffRequest.find(params[:id])

      if @change_tariff_request.update(change_tariff_request_params)
        if @change_tariff_request.processed
          consumer = @change_tariff_request.consumer
          if @change_tariff_request.state == "accepted"

            # change tariff for consumer
            consumer.update(tariff_id: @change_tariff_request.tariff.id)

            # recalculate tariff_expiration_at for current tariff
            consumer.update(tariff_expiration_at: (Date.current + (consumer.balance / (consumer.tariff.price / consumer.tariff.expiration_days.to_f)).to_f))

            # send email to consumer with comment from admin
            email = {
              html: render_to_string(:partial => 'admin/change_tariff_requests/accepted', :locals => { consumer: consumer, change_tariff_request: @change_tariff_request }),
              text: 'Text',
              subject: 'Ваша заявка на зміну тарифу успішно опрацьована на сайті ZizenCom',
              from: {
                name: 'ZizenCom',
                email: 'zyzen.vasyl@student.uzhnu.edu.ua'
              },
              to: [
                {
                  email: consumer.email
                }
              ]
            }

          else
            # send email to consumer with comment from admin
            email = {
              html: render_to_string(:partial => 'admin/change_tariff_requests/rejected', :locals => { consumer: consumer, change_tariff_request: @change_tariff_request }),
              text: 'Text',
              subject: 'Ваша заявка на зміну тарифу успішно опрацьована на сайті провайдера ZizenCom',
              from: {
                name: 'ZizenCom',
                email: 'zyzen.vasyl@student.uzhnu.edu.ua'
              },
              to: [
                {
                  email: consumer.email
                }
              ]
            }
          end
          @smtp_service.send_email(email)
        end
        redirect_to admin_change_tariff_requests_path, notice: 'Change tariff_request was updated'
      end
    end

    private

    def change_tariff_request_params
      params.require(:change_tariff_request).permit(:consumer_id, :tariff_id, :processed, :state, :comment)
    end
  end
end
