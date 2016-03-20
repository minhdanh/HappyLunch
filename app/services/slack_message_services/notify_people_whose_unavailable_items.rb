module SlackMessageServices
  class NotifyPeopleWhoseUnavailableItems < Base
    def self.call(items)
      content = format_content(items)
      send_message(content)
    end

    def self.format_content(items)
      members = items.map { |item| "@#{item.username}" }
      dishes = items.map { |item| item.dish.name if item.dish }.compact.uniq
      to_be  = dishes.size > 1 ? "are" : "is"
      "#{members.join(', ')} Hơ hơ, #{dishes.join(', ')} #{to_be} hết mất rồi. Chọn món khác đi bồ tèo. 5 phút sau nữa mền sẽ tự đặt lại."
    end
  end
end
