# 代码生成时间: 2025-09-18 08:14:57
# 购物车服务
# 此模块实现了购物车的基本功能，包括添加商品、删除商品和获取购物车内容等。

require 'cuba'
require 'data_mapper'
require 'dm-timestamps'
require 'dm-validations'
require 'json'
require 'securerandom'

# 定义商品模型
class Product
  include DataMapper::Resource
  property :id, Serial
  property :name, String, required: true
  property :price, Float, required: true
end

# 定义购物车项模型
class CartItem
  include DataMapper::Resource
  property :id, Serial
  property :product_id, Integer, required: true
  property :quantity, Integer, required: true, default: 1
end

# 定义购物车模型
class Cart
  include DataMapper::Resource
  property :id, Serial
  property :user_id, Integer, required: true
  has n, :items, 'CartItem', 'cart_id = :id'
end

# 购物车服务
class CartService
  # 添加商品到购物车
  def add_product_to_cart(cart_id, product_id, quantity)
    cart = Cart.get(cart_id)
    if cart.nil?
      raise '购物车不存在'
    end

    product = Product.get(product_id)
    if product.nil?
      raise '商品不存在'
    end

    item = CartItem.first_or_create(cart_id: cart_id, product_id: product_id) do |item|
      item.quantity = quantity
    end
  end

  # 从购物车删除商品
  def remove_product_from_cart(cart_id, product_id)
    cart = Cart.get(cart_id)
    if cart.nil?
      raise '购物车不存在'
    end

    item = CartItem.first(cart_id: cart_id, product_id: product_id)
    if item.nil?
      raise '商品不存在'
    end

    item.destroy
  end

  # 获取购物车内容
  def get_cart_content(cart_id)
    cart = Cart.get(cart_id)
    if cart.nil?
      raise '购物车不存在'
    end

    cart.items.map do |item|
      {
        product_id: item.product_id,
        quantity: item.quantity
      }
    end
  end
end

# Cuba 路由
Cuba.define do
  on get, 'add_product' do |product_id, quantity|
    product_id = product_id.to_i
    quantity = quantity.to_i
    cart_service = CartService.new
    cart_service.add_product_to_cart(1, product_id, quantity) # 假设购物车ID为1
    res.write("商品添加成功")
  end

  on get, 'remove_product' do |product_id|
    product_id = product_id.to_i
    cart_service = CartService.new
    cart_service.remove_product_from_cart(1, product_id) # 假设购物车ID为1
    res.write("商品删除成功")
  end

  on get, 'get_cart' do
    cart_service = CartService.new
    content = cart_service.get_cart_content(1) # 假设购物车ID为1
    res.write(JSON.pretty_generate(content))
  end
end