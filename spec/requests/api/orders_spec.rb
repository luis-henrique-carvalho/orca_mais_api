# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/orders', type: :request do
  path '/api/orders' do
    get 'List all orders', params: { use_as_request_example: true } do
      tags 'Orders'
      security [bearer_auth: []]
      consumes 'application/json'

      generate_response_examples

      let(:Authorization) { authenticated_header({}, create(:user))['Authorization'] }

      before do
        create_list(:order, 3)
      end

      response 200, 'Successful' do
        schema '$ref': '#/components/schemas/orders/responses/index'

        it 'returns the correct data length' do
          debugger
          expect(response_body['data'].size).to eq(3)
        end

        run_test!
      end
    end
  end
end
