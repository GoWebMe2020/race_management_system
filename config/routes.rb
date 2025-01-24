Rails.application.routes.draw do
  resources :races
  resources :students

  root "students#index"
end
