Rails.application.routes.draw do
  resources :races
  resources :students

  root "races#index"
end
