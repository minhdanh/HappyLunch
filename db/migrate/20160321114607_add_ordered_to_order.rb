class AddOrderedToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :ordered, :boolean, default: false
  end
end
