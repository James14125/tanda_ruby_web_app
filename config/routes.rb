Rails.application.routes.draw do
  root "home#index"

  devise_for :users

  get "/tanda/me", to: "tanda_auth#me"
  get "/tanda", to: "tanda_auth#show"
end
