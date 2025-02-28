# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    devise_for :users, path: 'auth', path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'signup'
    }, controllers: {
      sessions: 'auth/sessions',
      registrations: 'auth/registrations'
    }

    namespace :v1 do
      resources :users, only: %i[show update]
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
