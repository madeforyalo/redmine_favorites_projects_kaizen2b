# frozen_string_literal: true

Rails.application.routes.draw do
  resources :favorites, only: [:index, :create, :destroy] do
    collection do
      post :toggle
    end
  end
end