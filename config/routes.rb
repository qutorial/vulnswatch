Rails.application.routes.draw do
  resources :tags
  authenticate :user do
    resources :reactions
    resources :tags
    resources :vulnerabilities, only: [:index, :show, :update, :edit]
    resources :projects
    get 'nvd_update', to: 'vulnerabilities#nvd', as: 'nvd_update'
    get 'nvd_load_year/:year', to: 'vulnerabilities#nvd_load_year', as: 'nvd_load_year'
    get 'relevant_vulnerabilities', to: 'vulnerabilities#relevant', as: 'relevant_vulnerabilities'
  end
  
  DisableRegistration = Rails.env.production? && false
  if DisableRegistration
    devise_for :users, :controllers => { :registrations => "registrations" } 
  else
    devise_for :users
  end

  root to: 'static#home'

  get 'noscript', to: 'static#noscript'
  get 'about', to: 'static#about'
  get 'terms', to: 'static#terms'
  get 'impressum', to: 'static#impressum', as: 'impressum'
  get 'datenschutz', to: 'static#datenschutz', as: 'datenschutz'
  get 'contact', to: 'static#contact', as: 'contact'
  
end
