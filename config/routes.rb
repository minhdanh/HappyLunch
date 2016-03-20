Rails.application.routes.draw do
  post "lunch", to: "command_routing#index"
  resources :orders
end
