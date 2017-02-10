# frozen_string_literal: true
Rails.application.routes.draw do
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
  end

  resources :attachments, only: :destroy

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :list, on: :collection
      end
      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:index, :show, :create]
      end
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
