ActiveAdmin.register Consumer do

  permit_params :username, :email, :password, :password_confirmation, :full_name, :phone,
                :address, :longitude, :latitude, :tariff_id, :balance, :tariff_expiration_at

  index do
    selectable_column
    id_column
    column :username
    column :email
    column :full_name
    column :phone
    column :address
    column :longitude
    column :latitude
    column :tariff_id
    column :balance
    column :tariff_expiration_at
    actions
  end

  filter :username
  filter :email
  filter :full_name
  filter :phone
  filter :address
  filter :longitude
  filter :latitude
  filter :tariff_id
  filter :balance
  filter :tariff_expiration_at

  form do |f|
    f.inputs "Consumer Details" do
      f.input :email
      f.input :full_name
      f.input :phone
      f.input :address
      f.input :longitude, as: :string
      f.input :latitude, as: :string
      f.input :tariff_id, as: :select, collection: Tariff.all.map { |u| ["#{u.name}", u.id] }
      f.input :balance
      f.input :tariff_expiration_at
    end
    f.actions
  end

  show do
    attributes_table do
      row :username
      row :email
      row :full_name
      row :phone
      row :address
      row :longitude
      row :latitude
      row :tariff_id
      row :balance
      row :tariff_expiration_at
    end
  end

  controller do
    def create
      # generate random password and username for consumer

      @consumer = Consumer.new(consumer_params)
      @consumer.password = Devise.friendly_token.first(8)
      @consumer.username = Devise.friendly_token.first(12)
      if @consumer.save!
        redirect_to admin_consumers_path, notice: 'Consumer was successfully created with password: ' + @consumer.password

        email = {
          html: render_to_string(:partial => 'admin/consumers/create_email_template', :locals => { consumer: @consumer, password: @consumer.password }),
          text: 'Text',
          subject: 'Вас акаунт було створено на сайті провайдера ZizenCom',
          from: {
            name: 'ZizenCom',
            email: 'zyzen.vasyl@student.uzhnu.edu.ua'
          },
          to: [
            {
              email: @consumer.email
            }
          ]
        }

        @smtp_service.send_email(email)
      else
        # try to regenerate username
        @consumer.username = Devise.friendly_token.first(12)
        if @consumer.save!
          redirect_to admin_consumers_path, notice: 'Consumer was successfully created with password: ' + @consumer.password
        else
          redirect_to admin_consumers_path, notice: 'Consumer was not created'
        end
      end
    end

    def update
      @consumer = Consumer.find(params[:id])

      if @consumer.update(consumer_params)

        # recalculate tariff_expiration_at for current tariff
        @consumer.update(tariff_expiration_at: (Date.current + (@consumer.balance / (@consumer.tariff.price / @consumer.tariff.expiration_days.to_f)).to_f))

        redirect_to admin_consumers_path, notice: 'Consumer was updated'

      end
    end

    def get_all_consumers

      consumers = []

      Consumer.all.map do |consumer|
        consumers.push({ id: consumer.id, longitude: consumer.longitude,
                         latitude: consumer.latitude, address: consumer.address,
                         tariff: consumer.tariff.name, phone: consumer.phone })
      end

      respond_to do |format|
        format.json { render json: { consumers: consumers } }
      end
    end

    private

    def consumer_params
      params.require(:consumer).permit(:email, :full_name, :phone,
                                       :address, :longitude, :latitude, :tariff_id, :balance, :tariff_expiration_at)
    end
  end
end
