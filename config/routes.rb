# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  devise_for :users, path: 'api/auth', path_names: {
    sign_in: :login,
    sign_out: :logout,
    registration: :signup
  }, controllers: {
    sessions: 'api/auth/sessions',
    registrations: 'api/auth/registrations'
  }

  namespace :api do
    namespace :v1 do
      resources :categories, only: %i[index create]
      resources :users, only: %i[show update]
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
