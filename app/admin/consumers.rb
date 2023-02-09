ActiveAdmin.register Consumer do
  permit_params :address, :phone, :user_name, :tariff_id, :balance, :tariff_expiration_at

  includes :tariff

  scope :all
  scope :soon_expirats

  index do
    selectable_column
    id_column
    column :active
    column :address
    column :phone
    column :user_name
    column :tariff
    column :balance
    column :tariff_expiration_at
    column :created_at
    actions
  end

  # permit_params do
  #   permitted = [:address, :phone, :user_name, :tariff_id, :balance, :tariff_expiration_days]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
