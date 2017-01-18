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
    end
  end

  resources :attachments, only: :destroy

  root to: 'questions#index'
end
