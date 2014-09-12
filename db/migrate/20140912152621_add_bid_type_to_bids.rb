class AddBidTypeToBids < ActiveRecord::Migration
  def change
    add_column :bids, :bid_type, :string, :null => false, :default => "regular"
  end
end
