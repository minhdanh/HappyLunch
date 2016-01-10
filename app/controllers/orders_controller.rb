class OrdersController < ApplicationController
  before_action :check_request, only: :create

  def create
    SaveOrderItemService.call(params)
    render status: 200, json: "create"
  end

  private

  def check_request
    return render json: {error: "No access permission"}, status: 401 if params["token"] != ENV["OUTGOING_TOKEN"]
  end
end