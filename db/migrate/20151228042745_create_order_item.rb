class CreateOrderItem < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :user, index: true, foreign_key: true
      t.references :dish, index: true, foreign_key: true
      t.integer :quantity
    end
  end
end
