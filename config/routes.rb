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

  post '/push/:path', to: 'push#call'
end
