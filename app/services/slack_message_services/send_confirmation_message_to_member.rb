module SlackMessageServices
  class SendConfirmationMessageToMember < Base
    def self.call(order_items)
      content = format_content(order_items)
      send_message(content)
    end

    def self.format_content(order_items)
      username = "@#{order_items.first.username}"
      dishes = order_items.map { |item| item.dish.name if item.dish }.compact.uniq
      "#{username} Đặt món #{dishes.join(', ')} xong rồi nha."
    end
  end
end
