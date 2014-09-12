Rails.application.routes.draw do
  resources :leads
  resources :bids

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'leads#index'
  devise_for :users

end
