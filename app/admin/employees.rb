ActiveAdmin.register Employee do
  permit_params :email, :password, :password_confirmation, :role,:name,:phone
  form partial: "form"

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :phone
    column :role
    column :created_at
    actions
  end

  filter :name
  filter :email
  filter :phone
  filter :role, as: :select, collection: Employee.roles
  filter :created_at
end
