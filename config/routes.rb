Rails.application.routes.draw do
  resources :daily_statuses do
    collection do
      get 'verify_statuses'
    end
  end
  resources :admin do
    collection do
      get 'admin_panel'
      get 'add_status'
    end
  end
  resources :projects do
    collection do
      get 'latest_projects'
      get 'manage_projects'
      get 'remove_employe_from_project'
    end
  end
  resources :trainings do
    collection do
      get 'list_training'
    end
  end
  
  devise_for :users
  get 'users/list_users', to: 'users#list_users', as: 'list_users'
  get 'users/new_joiners', to: 'users#new_joiners', as: 'new_joiners'
  get 'users/birthdays', to: 'users#birthdays', as: 'birthdays'
  get '/users/:id', to: 'users#show', as: 'show_user'
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
