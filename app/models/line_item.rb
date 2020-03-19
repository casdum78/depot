class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product, optional: true
  belongs_to :cart

  def total_price(line_item)
    line_item.price * quantity
    #product.price * quantity
  end
end
