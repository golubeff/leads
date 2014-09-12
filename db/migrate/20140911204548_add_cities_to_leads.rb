class AddCitiesToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :cities, :text
  end
end
