Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :readings, only: [:create, :show]
  resources :thermostats, only: [:show, :index] do
    member do
      get 'stats'
    end
  end
end
