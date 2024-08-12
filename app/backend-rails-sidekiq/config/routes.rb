Rails.application.routes.draw do
  resources :orders, only: [ :new, :create, :show ]

  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  root "welcome#show"
end
