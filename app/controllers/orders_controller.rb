class OrdersController < ApplicationController

  def create
    service = SaveOrderItemService.new(params)

    if service.call
      SlackMessageServices::SendConfirmationMessageToMember.call(service.saved_order_items)
    end

    render status: 200, json: "create"
  end
end
