# 代码生成时间: 2025-09-07 22:42:56
# Shopping Cart implementation using Ruby and CUBA framework

# Define a Product class to represent items in the cart
class Product
  attr_accessor :id, :name, :price

  def initialize(id, name, price)
    @id = id
    @name = name
    @price = price
  end
end


# Define a CartItem class to represent individual items in the shopping cart
class CartItem
  attr_accessor :product, :quantity

  def initialize(product, quantity = 1)
    @product = product
    @quantity = quantity
  end

  def total_price
    @product.price * @quantity
  end
end

# Define a ShoppingCart class to manage the cart
class ShoppingCart
  attr_accessor :items

  def initialize
    @items = []
  end

  def add_item(product, quantity = 1)
    existing_item = @items.find { |item| item.product.id == product.id }
    if existing_item
      existing_item.quantity += quantity
    else
      @items << CartItem.new(product, quantity)
    end
  end

  def remove_item(product)
    @items.delete_if { |item| item.product.id == product.id }
  end

  def calculate_total
    @items.sum(&:total_price)
  end
end

# Example usage
if __FILE__ == $0
  # Create some products
  product1 = Product.new(1, 'Apple', 0.5)
  product2 = Product.new(2, 'Banana', 0.3)

  # Create a shopping cart
  cart = ShoppingCart.new

  # Add items to the cart
  cart.add_item(product1, 2)
  cart.add_item(product2, 3)

  # Calculate and print the total cost of the cart
  puts 'Total cost: $' + cart.calculate_total.to_s

  # Remove an item from the cart
  cart.remove_item(product1)

  # Print the updated total cost of the cart
  puts 'Updated total cost: $' + cart.calculate_total.to_s
end