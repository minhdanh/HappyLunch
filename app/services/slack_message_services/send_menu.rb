module SlackMessageServices
  class SendMenu < Base
    def self.call
      content = format_content
      send_message(content)
    end

    def self.format_content
      content = ["Thực đơn hiện có các món sau:\n"]
      Dish.today.order(:item_number).each do |dish|
        content << "#{dish.item_number}. #{dish.name} - #{dish.price} VND"
      end
      content.join("\n")
    end
  end
end
