require 'sidekiq/web'
# APIモードでもSidekiqのWebを閲覧するための設定
# https://github.com/sidekiq/sidekiq/issues/4850#issuecomment-810880012
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"

Rails.application.routes.draw do
  resources :orders, only: [ :new, :create, :show ]

  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  mount Sidekiq::Web => '/sidekiq'
  root "welcome#show"
end
