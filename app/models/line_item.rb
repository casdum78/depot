class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  def total_price(line_item)
    line_item.price * quantity
    #product.price * quantity
  end
end
