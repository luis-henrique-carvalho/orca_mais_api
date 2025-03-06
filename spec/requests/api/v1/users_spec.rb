# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  let(:current_user) { create(:user) }

  path '/api/v1/users/{id}' do
    get 'Show User', params: { use_as_request_example: true } do
      tags 'Users'
      security [bearer_auth: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string

      let(:id) { current_user.id }
      let(:Authorization) { authenticated_header({}, current_user)['Authorization'] }

      generate_response_examples

      response 200, 'Successful' do
        schema '$ref': '#/components/schemas/v1/users/responses/show'

        run_test!
      end

      response 401, 'Unauthorized' do
        let(:Authorization) { nil }
        let(:id) { create(:user).id }

        it 'returns correct error message' do
          expect_error('auth', 'unauthenticated', message_key_type: 'devise.failure')
        end

        run_test!
      end

      response 404, 'Not found' do
        let(:id) { 'not_an_id' }

        it 'returns correct error message' do
          expect_error('base', 'active_record.record_not_found', options: { model: 'User', id: 'not_an_id' })
        end

        run_test!
      end
    end

    put 'Update User', params: { use_as_request_example: true } do
      tags 'Users'
      security [bearer_auth: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :user, in: :body, schema: { '$ref': '#/components/schemas/v1/users/requests/update' }

      let(:id) { current_user.id }
      let(:Authorization) { authenticated_header({}, current_user)['Authorization'] }
      let(:user) { nil }

      generate_response_examples

      response 200, 'Successful' do
        let(:user) { user_attributes }
        let(:user_attributes) { { full_name: 'Dummy Name', email: 'admin@acme.com', cpf: '12496062095' } }

        schema '$ref': '#/components/schemas/v1/users/responses/show'

        it 'updates the user' do
          expect(response_body['data']).to include(user_attributes)
        end

        run_test!
      end

      response 422, 'Unprocessable entity' do
        let(:user) { { user: { email: 'invalid_email' } } }

        it 'returns correct error message' do
          expect_error('email', 'invalid')
        end

        run_test!
      end

      response 401, 'Unauthorized' do
        let(:Authorization) { nil }
        let(:id) { create(:user).id }

        it 'returns correct error message' do
          expect_error('auth', 'unauthenticated', message_key_type: 'devise.failure')
        end

        run_test!
      end

      response 404, 'Not found' do
        let(:id) { 'not_an_id' }

        it 'returns correct error message' do
          expect_error('base', 'active_record.record_not_found', options: { model: 'User', id: 'not_an_id' })
        end

        run_test!
      end
    end
  end
end
