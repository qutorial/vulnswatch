Rails.application.routes.draw do
  resources :vulnerabilities
  devise_for :users
  root to: 'static#home'
end
