require 'nokogiri'
require 'open-uri'

class GetMenuService
  def self.call
    item_number = 0
    init_order
    doc = get_html('http://giachanhcamtuyet.com.vn/index.php?m=dat-tiec&id=12&t=orders&s=1')

    get_elements(doc, "div.list_item").each do |item|
      name_element = get_element(item, "div.name")
      price_element = get_element(item, "div.price input")

      next unless valid_dish?(price_element["value"].to_f)

      item_number += 1
      insert_or_update_dish(name_element.text, price_element["value"].to_f, item_number)
    end
  end

  def self.insert_or_update_dish(name, price, item_number)
    dish = Dish.find_or_initialize_by(name: name)
    dish.price = price
    dish.item_number = item_number
    dish.save
  end

  def self.init_order
    Order.create(order_date: Time.zone.now) unless Order.today.first
    Dish.update_all(item_number: nil)
  end

  def self.get_html(url)
    Nokogiri::HTML(open(url))
  end

  def self.get_element(html, selector)
    html.at_css(selector)
  end

  def self.get_elements(html, selector)
    html.css(selector)
  end

  def self.valid_dish?(price)
    price >= 20_000 && price <= 50_000
  end
end
