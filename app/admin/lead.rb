ActiveAdmin.register Lead do


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

  permit_params :service_kind, :adults, :kids, :bedrooms, :bathrooms,
                :price_from, :price_to, :movein_date, :moveout_date,
                :contact_name, :contact_email, :phone_number, :cities, :notes

  form do |f|
    f.inputs do
      f.input :service_kind, as: :select, collection: Lead::SERVICES_HUMAN, prompt: "Select service type", label: "Leads wants to"
    end 
    f.inputs do
      f.input :cities, as: :string
      f.input :movein_date, as: :datepicker
      f.input :moveout_date, as: :datepicker
    end
    f.inputs do
      f.input :adults
      f.input :kids
      f.input :bedrooms
      f.input :bathrooms
    end 
    f.inputs do
      f.input :price_from, label: "Price from, USD"
      f.input :price_to, label: "Price to, USD"
    end 
    f.inputs :contact_name, :contact_email, :phone_number, :notes
    f.actions
  end


  

end
