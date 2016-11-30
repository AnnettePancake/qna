# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :questions do
    resources :answers, except: [:index, :show]
  end

  post '/answers/:id/toggle_best', to: 'answers#toggle_best'

  root to: 'questions#index'
end
