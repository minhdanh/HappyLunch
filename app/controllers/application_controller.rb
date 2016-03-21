class ApplicationController < ActionController::API
  # before_action :check_request

  private

  def check_request
    return render json: {error: "No access permission"}, status: 401 if params["token"] != ENV["OUTGOING_TOKEN"]
  end
end
