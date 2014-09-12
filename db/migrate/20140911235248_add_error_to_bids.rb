class AddErrorToBids < ActiveRecord::Migration
  def change
    add_column :bids, :error, :string
  end
end
