class CommandRoutingController < ApplicationController
  def index
    raw_command = params[:text].strip
    command_params = raw_command.split(/(menu|order) *([\d,\s]+)*/)
    if command_params[1] == "menu"
      render text: SlackMessageServices::SendMenu.format_content
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
    end
  end
end
