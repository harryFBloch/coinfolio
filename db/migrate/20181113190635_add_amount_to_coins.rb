class AddAmountToCoins < ActiveRecord::Migration
  def change
    add_column :coins, :amount, :float
  end
end
