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

      let(:search) { nil }
      let(:Authorization) { authenticated_header({}, current_user)['Authorization'] }

      generate_response_examples

      before do
        create_list(:category, 3)
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

      response 401, 'Unauthorized' do
        let(:Authorization) { nil }
        let(:id) { create(:user).id }

        it 'returns correct error message' do
          expect_error('auth', 'invalid', options: { authentication_keys: 'email' }, message_key_type: 'devise.failure')
        end

        run_test!
      end
    end
  end
end
