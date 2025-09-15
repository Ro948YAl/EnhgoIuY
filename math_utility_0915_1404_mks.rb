# 代码生成时间: 2025-09-15 14:04:55
# math_utility.rb
# This Ruby script provides a set of mathematical calculation tools
# using the CUBA framework.

require 'cuba' # Include the CUBA framework

# Define a class for our mathematical operations
class MathUtility
  # Adds two numbers together
  def add(x, y)
    x + y
  end

  # Subtracts the second number from the first
  def subtract(x, y)
    x - y
  end

  # Multiplies two numbers
  def multiply(x, y)
    x * y
  end

  # Divides the first number by the second, handles division by zero
  def divide(x, y)
    raise ArgumentError, 'Cannot divide by zero' if y.zero?
    x.to_f / y
  end
end

# Define the CUBA app
Cuba.define do
  # Route for addition
  on get do
    on 'add' do
      res.write MathUtility.new.add(*params[:numbers].split(',').map(&:to_f))
    end
  end

  # Route for subtraction
  on get do
    on 'subtract' do
      res.write MathUtility.new.subtract(*params[:numbers].split(',').map(&:to_f))
    end
  end

  # Route for multiplication
  on get do
    on 'multiply' do
      res.write MathUtility.new.multiply(*params[:numbers].split(',').map(&:to_f))
    end
  end

  # Route for division
  on get do
    on 'divide' do
      res.write MathUtility.new.divide(*params[:numbers].split(',').map(&:to_f))
    rescue ArgumentError => e
      res.write e.message
    end
  end

  # Default route
  on get do
    res.write 'Welcome to the Math Utility. Use /add, /subtract, /multiply, /divide'
  end
end
