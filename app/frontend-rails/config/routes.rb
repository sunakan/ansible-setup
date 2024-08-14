Rails.application.routes.draw do
  resources :orders, only: [ :new, :create, :show ]
  # todo: simulated behaviorsの実装
  root 'welcome#show'
end
