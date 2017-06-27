Rails.application.routes.draw do
  resources :vulnerabilities
  get 'nvd_update', to: 'vulnerabilities#nvd', as: 'nvd_update'

  devise_for :users
  root to: 'static#home'
end
