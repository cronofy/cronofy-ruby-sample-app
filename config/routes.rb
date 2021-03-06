Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "root#show"

  resource :session, only: [:create, :destroy]

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'

  resources :profiles, only: [:index] do
    resources :calendars, only: [:show, :new, :create] do
      resources :events, only: [:show, :new, :create, :destroy, :edit, :update]
    end
  end

  resources :channels, only: [:index, :new, :create, :show]
  resources :smart_invites, only: [:index, :new, :create, :show, :destroy]

  resources :availability, only: [:index]
  resources :free_busy, only: [:index]

  get '/availability', controller: :availability, action: :index
  post '/availability', controller: :availability, action: :view
  get '/availability/account_id', controller: :availability, action: :account_id

  resource :enterprise_connect, only: [:show, :new, :create] do
    post '/service_accounts_auth_callback/:user_id', action: :service_account_auth_callback, as: :auth_callback
  end

  post '/push/:path', to: 'push#call'
  post '/push/service_account_user/:user_id', to: 'push#service_account_user_call'
  post '/push/smart_invite', to: 'push#smart_invite'

  resources :service_account_users, only: [:show] do
    resources :calendars, only: [:show, :new, :create], controller: 'service_account_user_calendars' do
      resources :events, only: [:show, :new, :create, :destroy, :edit, :update], controller: 'service_account_user_events'
    end
  end
end
