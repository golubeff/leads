class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.integer :user_id, :null => false
      t.integer :lead_id, :null => false
      t.integer :bid, :null => false
      t.timestamps
    end
  end
end
