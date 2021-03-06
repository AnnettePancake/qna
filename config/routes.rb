# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    post 'send_email_confirmation', to: 'omniauth_callbacks#send_email_confirmation',
                                    as: :send_email_confirmation
    get 'email_confirmation/:token', to: 'omniauth_callbacks#email_confirmation',
                                     as: :email_confirmation
  end

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
    resources :subscriptions, only: [:create, :destroy], shallow: true
  end

  resources :attachments, only: :destroy
  get '/search', to: 'search#show', as: :search

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:index, :show, :create]
      end
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
