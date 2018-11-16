class AddCurrentPriceToCoins < ActiveRecord::Migration
  def change
    add_column :coins, :current_price, :float
  end
end
