class CreateCoins < ActiveRecord::Migration
  def change
    create_table :coins do |t|
      t.float :price_paid
      t.string :name
      t.string :ticker
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
