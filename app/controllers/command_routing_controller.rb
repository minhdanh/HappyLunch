class CommandRoutingController < ApplicationController
  def index
    raw_command = params[:text].strip
    command_params = raw_command.split(/(menu|orders|cancel|order) *([\d,\s]+)*/)
    if command_params[1] == "menu"
      message = "Thực đơn hiện có các món sau:\n"
      if Order.today.first.ordered?
        message << "(Nhưng mà đã đặt xong hết rồi, thím muốn thì mai đặt nha)\n"
      end
      message << SlackMessageServices::SendMenu.format_content
      render text: message
    elsif command_params[1] == "orders"
      text = ""
      order_items = Order.today.first.order_items
      order_items.pluck(:dish_id).uniq.each do |dish_id|
        dish = Dish.find_by(id: dish_id)
        text << "#{dish.item_number}. #{dish.name} - #{dish.price} VNĐ ("
        sub_order_items = order_items.where(dish_id: dish_id)
        text << sub_order_items.map(&:username).join(", ")
        text << ")\n"
      end
      if text == ""
        render text: "Chưa có mống nào đặt cơm :flushed: :-/"
      else
        message = "Danh sách đặt món:\n"
        if Order.today.first.ordered?
          message << "(Đã đặt xong)\n"
        end
        render text: text.prepend("#{message}\n")
      end
    elsif command_params[1] == "order"
      if Order.today.first.ordered?
        render text: "Trễ rồi cưng ơi. Đã đặt cơm xong xuôi hết rồi :sweat_smile:"
      else
        if command_params[2].present?
            service = SaveOrderItemService.new(params["user_name"], command_params[2])
            if service.call
              render text: SlackMessageServices::SendConfirmationMessageToMember.format_content(service.saved_order_items)
            else
              render text: "Bị lỗi gì rồi, hông đặt được cơm. :scream:"
            end
        else
          render text: "Gõ lệnh không đúng rồi ku."
        end
      end
    elsif command_params[1] == "cancel"
      render text: "Ừm, chắc là bạn muốn hủy món đã đặt, nhưng chưa có lệnh này. Bạn ráng đợi nha :))"
    else
      p command_params[1]
      render text: "Hổng biết là có lệnh này :))"
    end
  end
end
