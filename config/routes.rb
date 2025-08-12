# frozen_string_literal: true
Rails.application.routes.draw do
  resources :favorites, only: [:index] do
    collection { post :toggle }
  end
end
