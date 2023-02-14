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
      end
    end

    private

    def consumer_params
      params.require(:consumer).permit(:email, :full_name, :phone,
                                       :address, :longitude, :latitude, :tariff_id, :balance, :tariff_expiration_at)
    end
  end
end