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
end
