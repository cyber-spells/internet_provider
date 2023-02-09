ActiveAdmin.register Tariff do
  permit_params :name, :speed, :price, :expiration_days

  # permit_params do
  #   permitted = [:name, :speed, :price]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
