class CreateDish < ActiveRecord::Migration
  def change
    create_table :dishes do |t|
      t.string :title
      t.integer :price
    end
  end
end
