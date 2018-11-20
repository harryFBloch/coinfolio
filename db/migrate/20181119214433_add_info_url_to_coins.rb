class AddInfoUrlToCoins < ActiveRecord::Migration
  def change
    add_column :coins, :info_url, :string
  end
end
