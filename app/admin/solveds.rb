ActiveAdmin.register Solved do
  belongs_to :complaint
  menu false

  permit_params :text, :complaint_id, :employee_id

  # actions :new,:create,:show

  # permit_params do
  #   permitted = [:text, :complaint_id, :employee_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form partial: "form"

end
