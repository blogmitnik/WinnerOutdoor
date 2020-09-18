Rails.application.routes.draw do
  use_doorkeeper
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' },
  	path: '' # optional namespace or empty string for no space

  devise_scope :user do
    get "/auth/webgoal/callback" => "omniauth_callbacks#webgoal"
  end

  root 'pages#index'

  resources :newsletters
  resources :events

  namespace :api do
    namespace :v1 do
      resources :users
      get "/me", to: "credentials#me"
      put "/account/update", to: "account_update#update"
      get "/fast", to: "fast#index"

      devise_scope :user do
        post "/sign_up", to: "registrations#create"
        post "/sign_in", to: "tokens#create"
        delete "/logout", to: "tokens#destroy"
        put "/reset_password", to: "reset_password#create"
      end

      resources :events, only: [:index, :show, :create, :update, :destroy]
    end
  end

  get 'newsletters/create'

  # Check if user's password correct before delete account
  post "/delete_account" => "accounts#checkpass"

  get '*anything' => 'errors#routing_error'
end
