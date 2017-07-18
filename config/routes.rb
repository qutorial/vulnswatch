Rails.application.routes.draw do
  authenticate :user do
    resources :reactions
    resources :vulnerabilities, only: [:index, :show, :update, :edit]
    resources :projects
    get 'nvd_update', to: 'vulnerabilities#nvd', as: 'nvd_update'
    get 'nvd_load_year/:year', to: 'vulnerabilities#nvd_load_year', as: 'nvd_load_year'
    get 'relevant_vulnerabilities', to: 'vulnerabilities#index', as: 'relevant_vulnerabilities', defaults: {project: 0}
  end
  
  DisableRegistration = Rails.env.production? && false
  if DisableRegistration
    devise_for :users, :controllers => { :registrations => "registrations" } 
  else
    devise_for :users
  end

  root to: 'static#home'

  get 'noscript', to: 'static#noscript'
  
end
