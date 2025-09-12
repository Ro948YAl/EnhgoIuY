# 代码生成时间: 2025-09-12 08:44:15
# shopping_cart.rb
# This is a simple shopping cart implementation using Ruby.

# ShoppingCart class represents a shopping cart with items.
class ShoppingCart
  # Initialize an empty shopping cart.
  def initialize
    @items = []
  end

  # Add an item to the shopping cart.
  # item: [String, Hash] item name and its price as a hash.
  def add_item(item_name, item_price)
    # Check if the item_price is a valid number.
    unless item_price.is_a?(Numeric)
      raise ArgumentError, 'Item price must be a numeric value.'
    end
    @items.push({ name: item_name, price: item_price })
  end

  # Remove an item from the shopping cart.
  # item_name: [String] the name of the item to be removed.
  def remove_item(item_name)
    @items.delete_if { |item| item[:name] == item_name }
  end

  # Get the total price of all items in the shopping cart.
  def total_price
    @items.sum { |item| item[:price] }
  end

  # List all items in the shopping cart.
  def list_items
    @items.map { |item| item }
  end
end

# Example usage:
begin
  cart = ShoppingCart.new
  cart.add_item('Apple', 1.0)
  cart.add_item('Banana', 0.5)
  puts "Total price: "#{cart.total_price}""
  puts "Items in cart: "#{cart.list_items}""
  cart.remove_item('Apple')
  puts "Total price after removing Apple: "#{cart.total_price}""
  puts "Items in cart after removing Apple: "#{cart.list_items}""
rescue ArgumentError => e
  puts e.message
end