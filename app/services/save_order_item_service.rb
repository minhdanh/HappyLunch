class SaveOrderItemService
  LUNCH_CODE = ENV['LUNCH_CODE'].freeze
  attr_reader :info, :success, :saved_order_items

  def initialize(username, item_numbers)
    @username = username
    @item_numbers = item_numbers.split(",")
    @success = true
    @saved_order_items = []
  end

  # rubocop:disable MethodLength
  def call
    return false unless today_order
    destroy_old_orders(@username)
    begin
      Dish.where(item_number: @item_numbers).each do |dish|
        order_item = OrderItem.new(order: today_order, username: @username, dish: dish)
        @saved_order_items << order_item if order_item.save
      end
    rescue ActiveRecord::RecordInvalid
      return false
    end
    return true
  end
  # rubocop:enable MethodLength

  def today_order
    Order.today.last
  end

  def destroy_old_orders(username)
    OrderItem.where(order: today_order, username: username).destroy_all
  end
end
