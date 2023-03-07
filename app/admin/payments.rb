ActiveAdmin.register Payment do

  permit_params :title, :consumer_id, :sum, :tariff_id, :created_at, :updated_at

  index do
    selectable_column
    id_column
    column :title
    column :consumer_id
    column :sum
    column :tariff_id
    column :created_at
    column :updated_at
    actions
  end

  filter :title
  filter :consumer_id
  filter :sum
  filter :tariff_id
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs "Payment Details" do
      f.input :title
      f.input :consumer_id
      f.input :sum
      f.input :tariff_id
      f.input :created_at
      f.input :updated_at
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :consumer_id
      row :sum
      row :tariff_id
      row :created_at
      row :updated_at
    end
  end

end
