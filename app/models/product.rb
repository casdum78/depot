class Product < ApplicationRecord

  has_many :line_itens

  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url, presence:true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :title, uniqueness: true
  validates :image_url, allow_blank:true, format: {
    with: %r{\.(gif|jpg|png)\Z}i, 
    message: 'must be a URL for gif, JPG or PNG image'
  }
  validates :title, length:{minimum:10}, allow_blank:true

  private

  #ensure that there are no line itens referencing this product
  def ensure_not_referenced_by_any_line_item
    unless lines_items.empty?
      errors.add(:base, 'Lines Items present')
      throw :abort
    end
  end
end
