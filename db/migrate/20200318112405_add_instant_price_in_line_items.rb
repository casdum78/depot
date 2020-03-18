class AddInstantPriceInLineItems < ActiveRecord::Migration[5.1]
  def change
    add_column :line_items, :price, :integer, default: 1.00
  end
end
