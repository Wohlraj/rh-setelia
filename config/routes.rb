RhSetelia::Application.routes.draw do
  get 'profiles/new'

  get 'profiles/create'

  devise_for :admins
  resources :users do
    collection do
      match 'search' => 'users#search', via: [:get, :post], as: :search
    end
    resources :events
  end
  resources :admins
  resources :skills
  resources :profiles
  resources :categories
  resources :languages
  resources :events

  match '/home'   , to: 'static_pages#home',          via: 'get'

  root :to => 'static_pages#home'
  
end
