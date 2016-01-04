module SlackMessageServices
  class NotifyUnavailableDishes < Base
    attr_accessor :unavailable_hash
    def initialize(unavailable_item)
      @unavailable_item = unavailable_item
    end

    def call
      users_dishes = @unavailable_item.map {|item| "@#{item.username}: #{item.dish.name}" }
      content = "<!here> Sorry," + users_dishes.join(", ") + " unavailable, please order the new dish"
      SlackMessageServices::NotifyUnavailableDishes.send_message(content)
    end
  end
end
