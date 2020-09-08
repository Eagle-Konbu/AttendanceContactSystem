Rails.application.routes.draw do
  resources :line_group_for_bots
  resources :line_reply_messages
  resources :numbers
  root to: 'executive#index'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :executive_users
  get 'contacts/check_submitted'
  get 'contacts/check_practice_detail'
  get 'contacts/check_aveilable_practices'
  get 'contacts/after_submitted', to: 'contacts#after_submitted'
  get 'executive/index'
  get 'executive/executive_user_list'
  resources :members
  resources :practices
  get 'contacts/add'
  get 'contacts/add/:default_member_id', to: 'contacts#add'
  post 'contacts/add', to: 'contacts#create'
  get 'executive/contacts_list', to:'contacts#practice_list'
  get 'executive/contacts_list/:id', to: 'contacts#list'
  get 'executive/practices', to:'practices#index'
  get 'executive/members', to:'members#index'
  get 'executive/password_reset', to:'password_reset#index'
  post 'executive/password_reset', to: 'password_reset#reset'
  get 'executive/new_password/:id/:new_password', to: 'password_reset#show_new_password'
  post '/callback' => 'line_bot#callback'
  post '/callback_executive' => 'line_bot#callback_executive'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
