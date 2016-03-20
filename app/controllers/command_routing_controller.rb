class CommandRoutingController < ApplicationController
  def index
    raw_command = params[:text].strip
    command_params = raw_command.split(/(menu|orders|order) *([\d,\s]+)*/)
    if command_params[1] == "menu"
      render text: SlackMessageServices::SendMenu.format_content
    elsif command_params[1] == "orders"
      text = ""
      OrderItem.pluck(:dish_id).uniq.each do |dish_id|
        dish = Dish.find_by(id: dish_id)
        text << "#{dish.item_number}. #{dish.name} ("
        order_items = OrderItem.where(dish_id: dish_id)
        text << order_items.map(&:username).join(", ")
        text << ")\n"
      end
      if text == ""
        render text: "Nobody ordered yet."
      else
        render text: text
      end
    elsif command_params[1] == "order"
      if command_params[2].present?
          service = SaveOrderItemService.new(params["user_name"], command_params[2])
          if service.call
            render text: SlackMessageServices::SendConfirmationMessageToMember.format_content(service.saved_order_items)
          else
            render text: "Error when making order."
          end
      else
        render text: "Incorrect syntax"
      end
    else
      render text: "Command not recognized."
    end
  end
end
