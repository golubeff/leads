class AddStatusToBids < ActiveRecord::Migration
  def change
    add_column :bids, :status, :string, :null => false, :default => "pending"
  end
end
