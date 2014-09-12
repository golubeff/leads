class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.string :contact_name
      t.integer :service_kind
      t.integer :price_from
      t.integer :price_to
      t.datetime :created_at
      t.datetime :updated_at
      t.string :contact_email
      t.string :phone_number
      t.integer :adults
      t.integer :kids
      t.integer :bedrooms
      t.integer :bathrooms
      t.integer :user_id
      t.datetime :sold_at
      t.integer :bid
      t.datetime :trading_until
      t.datetime :movein_date
      t.datetime :moveout_date

      t.timestamps
    end
  end
end
