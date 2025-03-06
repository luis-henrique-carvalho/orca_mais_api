# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Categories', type: :request do
  let(:current_user) { create(:user) }

  path '/api/v1/categories' do
    get 'List Categories', params: { use_as_request_example: true } do
      tags 'Categories'
      security [bearer_auth: []]
      consumes 'application/json'
      parameter name: :search, in: :query, type: :string
      parameter name: :'q[user_id_eq]', in: :query, type: :string

      let(:search) { nil }
      let(:'q[user_id_eq]') { nil }
      let(:Authorization) { authenticated_header({}, current_user)['Authorization'] }

      generate_response_examples

      before do
        create_list(:category, 3, :with_user)
      end

      response 200, 'Successful' do
        schema '$ref': '#/components/schemas/v1/categories/responses/index'

        it 'returns the correct data length' do
          expect(response_body['data'].size).to eq(3)
        end

        it 'returns a pagination data' do
          expect(response_body['meta']['total']).to eq(3)
        end

        run_test!
      end

      response 200, 'Successful with search' do
        let(:search) { 'dummy' }

        before do
          create(:category, name: 'dummy')
        end

        it 'returns the correct data length' do
          expect(response_body['data'].size).to eq(1)
        end

        it 'returns a pagination data' do
          expect(response_body['meta']['total']).to eq(1)
        end

        run_test!
      end

      response 200, 'Filter by user_id or global' do
        let(:'q[user_id_eq]') { current_user.id }

        before do
          create(:category, user: current_user)
        end

        it 'returns the correct data length' do
          expect(response_body['data'].size).to eq(1)
        end

        it 'returns a pagination data' do
          expect(response_body['meta']['total']).to eq(1)
        end

        run_test!
      end

      response 401, 'Unauthorized' do
        let(:Authorization) { nil }

        it 'returns correct error message' do
          expect_error('auth', 'unauthenticated', message_key_type: 'devise.failure')
        end

        run_test!
      end
    end

    post 'Create Category', params: { use_as_request_example: true } do
      tags 'Categories'
      security [bearer_auth: []]
      consumes 'application/json'
      parameter name: :category, in: :body, schema: { '$ref': '#/components/schemas/v1/categories/requests/create' }

      let(:category) { nil }
      let(:Authorization) { authenticated_header({}, current_user)['Authorization'] }

      generate_response_examples

      response 200, 'Successful' do
        let(:category) { { category: categoy_attributes } }
        let(:categoy_attributes) { { name: 'dummy', description: 'dummy' } }

        schema '$ref': '#/components/schemas/v1/categories/responses/create'

        it 'returns the correct user' do
          expect(response_body['data']['user']['id']).to eq(current_user.id)
        end

        run_test!
      end
    end
  end
end
