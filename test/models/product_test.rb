require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  fixtures :products

  def new_product(image_url)
    Product.new(title:      "Blebs title",
                description:"yyyy",
                price:      1,
                image_url:  image_url)
  end

  test "atributos de programas não devem ser vazios" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
    # test "the truth" do
    #   assert true
  end

  test "Preco deve ser positivo" do
    product = Product.new(title: "Blebs title",
                          description: "yyyy",
                          image_url: "blebs.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
    product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
    product.errors[:price]

    product.price = 1
    assert product.valid?
    
  end

  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.jpg
             http://a.b.c/x/y/z/fred.gif}
    bad = %w{fred.doc fred.gif/more fred.gif.more}

    ok.each do |image_url|
      assert new_product(image_url).valid?,
      "#{image_url} shouldn't be invalid"
    end

    bad.each do |image_url|
      assert new_product(image_url).invalid?,
      "#{image_url} shouldn't be valid"
    end
    
  end

  test "unique ID title" do
    product=Product.new(title:      products(:ruby).title,
                description:"yyyy",
                price:      1,
                image_url:  "fred.gif")
    assert product.invalid?
    #assert_equal [I18n.translate('errors.message.taken')], product.errors[:title]
    assert_equal ['has already been taken'], product.errors[:title]
  end

  test "Tamanho minino Title 10 caracteres <10" do
    product=Product.new(title:      "Bleb",
                        description:"yyyy",
                        price:      1,
                        image_url:  "fred.gif")
    assert product.invalid?
    assert_equal ['is too short (minimum is 10 characters)'], product.errors[:title]
  end

  test "Tamanho minino Title 10 caracteres >10" do
    product=Product.new(title:      "Blebcheckneber preto",
                        description:"yyyy",
                        price:      1,
                        image_url:  "fred.gif")
    assert product.valid?
  end

end
