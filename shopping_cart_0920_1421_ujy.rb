# 代码生成时间: 2025-09-20 14:21:42
# shopping_cart.rb
# Shopping Cart implementation using Ruby and CUBA framework

require 'cuba'
require 'data_mapper'
require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'
require 'dm-aggregates'
require 'dm-migrations'
require 'dm-serializer'

# Define the database settings
DataMapper.setup(:default, 'sqlite3://shopping_cart.db')

# Define the Product model
class Product
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true, :length => 255
  property :price, Float, :required => true
  property :quantity, Integer, :default => 0
end

# Define the CartItem model
class CartItem
  include DataMapper::Resource

  property :id, Serial
  property :product_id, Integer, :required => true
  property :quantity, Integer, :default => 0
end

# Define the ShoppingCart class
class ShoppingCart
  include Cuba
  include DataMapper::Resource

  property :id, Serial
  property :cart_items, Array, :lazy => false

  def add_product(product_id, quantity)
    # Find the product
    product = Product.get(product_id)
    if product.nil?
      return {status: :error, message: 'Product not found'}
    end

    # Create or update cart item
    cart_item = cart_items.find { |item| item.product_id == product_id } || CartItem.new(:product_id => product_id)
    cart_item.quantity += quantity
    cart_items << cart_item unless cart_items.include?(cart_item)
    save

    {status: :success, message: 'Product added to cart'}
  end

  def remove_product(product_id)
    # Find and remove cart item
    cart_item = cart_items.find { |item| item.product_id == product_id }
    if cart_item.nil?
      return {status: :error, message: 'Product not found in cart'}
    end

    cart_items.delete(cart_item)
    save

    {status: :success, message: 'Product removed from cart'}
  end
end

# Define the application routes
Cuba.define do
  on get do
    on "cart" do
      # Display the cart items
      res.write "Cart Items: " + ShoppingCart.new.cart_items.to_s
    end

    on "add" do
      # Add a product to the cart
      product_id = params['product_id']
      quantity = params['quantity'].to_i

      if product_id.nil? || quantity <= 0
        res.write "Invalid product ID or quantity"
      else
        cart = ShoppingCart.new
        response = cart.add_product(product_id.to_i, quantity)
        res.write response[:message]
      end
    end

    on "remove" do
      # Remove a product from the cart
      product_id = params['product_id']

      if product_id.nil?
        res.write "Invalid product ID"
      else
        cart = ShoppingCart.new
        response = cart.remove_product(product_id.to_i)
        res.write response[:message]
      end
    end
  end
end

# Initialize the database
DataMapper.finalize
DataMapper.auto_upgrade!

# Run the application
Cuba.run!