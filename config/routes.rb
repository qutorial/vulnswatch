Rails.application.routes.draw do
  authenticate :user do
    resources :vulnerabilities, only: [:index, :show]
    get 'nvd_update', to: 'vulnerabilities#nvd', as: 'nvd_update'
  end

  devise_for :users
  root to: 'static#home'
  
end
