# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Auth', type: :request do
  path '/api/auth/login' do
    post 'Login user' do
      tags 'Auth'
      consumes 'application/json'
      parameter name: :body, in: :body, schema: { '$ref': '#/components/schemas/auth/requests/login' }

      generate_response_examples

      response 200, 'Successful' do
        let(:user) { create(:user, email: 'test@test', password: 'password') }
        let(:body) do
          {
            user: {
              email: user.email,
              password: 'password'
            }
          }
        end

        schema '$ref': '#/components/schemas/auth/responses/login'

        it 'returns authorization header' do |_example|
          expect(response.headers['Authorization'][0..6]).to eq 'Bearer '
        end

        it 'returns correct user' do |_example|
          expect(response_body['user']['email']).to eq user.email
        end

        run_test!
      end
    end
  end

  path '/api/auth/signup' do
    post 'Sign up user' do
      tags 'Auth'
      consumes 'application/json'
      parameter name: :body, in: :body, schema: { '$ref': '#/components/schemas/auth/requests/signup' }

      generate_response_examples

      response 200, 'Successful' do
        let(:user_attributes) do
          {
            email: 'teste@teste',
            password: 'password'
          }
        end
        let(:body) do
          {
            user: user_attributes
          }
        end

        schema '$ref': '#/components/schemas/auth/responses/login'

        it 'returns authorization header' do |_example|
          expect(response.headers['Authorization'][0..6]).to eq 'Bearer '
        end

        it 'returns correct user' do |_example|
          expect(response_body['user']['email']).to eq user_attributes[:email]
        end

        run_test!
      end
    end
  end

  path '/api/auth/logout' do
    delete 'Logout User' do
      tags 'Auth'
      consumes 'application/json'
      security [bearer_auth: []]

      response 200, 'Successful' do
        let(:user) { create(:user, password: 'password', jti: 'previous_jti') }
        let(:Authorization) { authenticated_header({}, user)['Authorization'] }

        it 'invalidates the JTI' do
          expect(user.reload.jti).not_to eq 'previous_jti'
        end

        run_test!
      end
    end
  end

  # TODO: Add tests for refresh token
end
