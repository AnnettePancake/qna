# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  concern :voteable do
    post :like, :dislike, on: :member
  end

  resources :questions do
    concerns :voteable
    resources :answers, except: [:index, :show], shallow: true do
      concerns :voteable
      post :toggle_best, on: :member
      resources :comments, only: [:new, :create, :destroy],
                           defaults: { commentable: 'answer' }
    end
    resources :comments, only: [:new, :create, :destroy], shallow: true,
                         defaults: { commentable: 'question' }
  end

  resources :attachments, only: :destroy

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
