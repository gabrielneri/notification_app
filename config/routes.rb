Rails.application.routes.draw do
  root to: redirect('/api-docs')

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      resources :notifications, only: %i[create show]
    end
  end
end
