Rails.application.routes.draw do
  authenticate :user do
    resources :vulnerabilities, only: [:index, :show]
    resources :projects
    get 'nvd_update', to: 'vulnerabilities#nvd', as: 'nvd_update'
  end

  if Rails.env.production?
    devise_for :users, :controllers => { :registrations => "registrations" } 
  else
    devise_for :users
  end

  root to: 'static#home'

  get 'noscript', to: 'static#noscript'
  
end
