# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: 'auth', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  }, controllers: {
    sessions: 'auth/sessions',
    registrations: 'auth/registrations'
  }

  get 'up' => 'rails/health#show', as: :rails_health_check
end
