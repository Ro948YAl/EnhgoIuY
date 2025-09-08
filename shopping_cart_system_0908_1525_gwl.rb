# 代码生成时间: 2025-09-08 15:25:53
# shopping_cart_system.rb

# ShoppingCart class represents a shopping cart with items and operations to manage them.
class ShoppingCart
  attr_reader :items
  attr_accessor :user

  # Initialize a new shopping cart with an empty item list.
  def initialize(user)
    @items = []
    @user = user
  end

  # Add an item to the shopping cart.
  # @param item [Item] the item to add to the cart.
  def add_item(item)
    # Check if the item is already in the cart.
    @items << item unless @items.include?(item)
  end

  # Remove an item from the shopping cart.
  # @param item [Item] the item to remove from the cart.
  def remove_item(item)
    @items.delete(item)
  rescue RuntimeError => e
    puts "Error: #{e.message}"
  end

  # Calculate the total price of items in the cart.
  # @return [Float] the total price of the items.
  def total_price
    @items.sum(&:price)
  end

  # Clear all items from the shopping cart.
  def clear
    @items.clear
  end
end

# Item class represents an item that can be added to the shopping cart.
class Item
  attr_accessor :name, :price

  # Initialize a new item with a name and price.
  def initialize(name, price)
    @name = name
    @price = price
  end
end

# Example usage:
begin
  user = 'User1'
  cart = ShoppingCart.new(user)
  item1 = Item.new('Apple', 0.99)
  item2 = Item.new('Banana', 0.50)
  cart.add_item(item1)
  cart.add_item(item2)
  puts "Total price: "#{cart.total_price}""
  cart.remove_item(item1)
  puts "Total price after item removal: "#{cart.total_price}""
  cart.clear
  puts "Total price after cart clearing: "#{cart.total_price}""
rescue StandardError => e
  puts "An error occurred: #{e.message}"
end