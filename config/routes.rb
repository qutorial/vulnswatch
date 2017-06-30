Rails.application.routes.draw do
  authenticate :user do
    resources :reactions
    resources :vulnerabilities, only: [:index, :show]
    resources :projects
    get 'nvd_update', to: 'vulnerabilities#nvd', as: 'nvd_update'
    get 'relevant_vulnerabilities', to: 'relevant_vulnerabilities#index', as: 'relevant_vulnerabilities'
  end
  
#  @@DisableRegistration = Rails.env.production? and false
#  if @@DisableRegistration
#    devise_for :users, :controllers => { :registrations => "registrations" } 
#  else
    devise_for :users
#  end

  root to: 'static#home'

  get 'noscript', to: 'static#noscript'
  
end
