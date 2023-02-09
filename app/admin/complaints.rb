ActiveAdmin.register Complaint do
  permit_params :employee_id, :consumer_id, :text, :user_name, :phone, :address, :state

  action_item :solve, only: :show  do
    link_to "Solve", new_admin_complaint_solved_path(resource)
  end

  scope :all
  Complaint.states.keys.each do |state|
    scope state.pluralize.to_sym, group: :state
  end

  # permit_params do
  #   permitted = [:employee_id, :consumer_id, :text, :user_name, :phone, :address]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    selectable_column
    id_column
    column :state
    column :phone
    column :user_name
    column :consumer
    column :employee
    column :created_at
    column :updated_at
    actions do |complaint|
      link_to "Закрити", closed_admin_complaint_path(complaint), class: "member_link" if complaint.open? || complaint.in_process?
    end
  end

  member_action :closed do
    resource.update(
      employee: current_employee,
      state: Complaint.states[:close_without_resolved],
    )

    redirect_to resource, notice: "Closed!"
  end

  show do |complaint|
    complaint.update(state: Complaint.states[:in_process], employee: current_employee) if complaint.open?

    attributes_table do
      row :state
      row :employee
      row :consumer
      row :user_name
      row :phone
      row :address
      row :text
    end
    panel "Рішення" do
      table_for complaint.solveds do
        column { |solved| link_to solved.id, admin_complaint_solved_path(complaint,solved) }
        column :employee
        column :text
        column :created_at
      end
    end
  end

end
