# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Transactions', type: :request do
  let(:current_user) { create(:user) }

  path '/api/v1/transactions' do
    get 'List Transactions', params: { use_as_request_example: true } do
      tags 'Transactions'
      security [bearer_auth: []]
      consumes 'application/json'
      parameter name: :search, in: :query, type: :string
      parameter name: :'q[category_id_eq]', in: :query, type: :string
      parameter name: :'q[created_at_gteq]', in: :query, type: :string
      parameter name: :'q[created_at_lteq]', in: :query, type: :string

      let(:search) { nil }
      let(:'q[category_id_eq]') { nil }
      let(:'q[created_at_lteq]') { nil }
      let(:'q[created_at_gteq]') { nil }
      let(:Authorization) { authenticated_header({}, current_user)['Authorization'] }

      generate_response_examples

      before do
        create_list(:transaction, 3, user: current_user)
      end

      response 200, 'Successful' do
        schema '$ref': '#/components/schemas/v1/transactions/responses/index'

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

        schema '$ref': '#/components/schemas/v1/transactions/responses/index'

        before do
          create(:transaction, name: 'dummy', user: current_user)
        end

        it 'returns the correct data length' do
          expect(response_body['data'].size).to eq(1)
        end

        it 'returns a pagination data' do
          expect(response_body['meta']['total']).to eq(1)
        end

        run_test!
      end

      response 200, 'Filter by category_id_eq' do
        let(:catagory) { create(:category) }
        let(:'q[category_id_eq]') { catagory.id }

        schema '$ref': '#/components/schemas/v1/transactions/responses/index'

        before do
          create(:transaction, category_id: catagory.id, user: current_user)
        end

        it 'returns the correct data length' do
          expect(response_body['data'].size).to eq(1)
        end

        it 'returns a pagination data' do
          expect(response_body['meta']['total']).to eq(1)
        end

        run_test!
      end

      response 200, 'Filter by created_at_lteq' do
        before do
          travel_to 4.days.ago do
            create(:transaction, user: current_user)
          end
        end

        let(:'q[created_at_lteq]') { 4.days.ago }

        schema '$ref': '#/components/schemas/v1/transactions/responses/index'

        it 'returns the correct data length' do
          expect(response_body['data'].size).to eq(1)
        end

        it 'returns a pagination data' do
          expect(response_body['meta']['total']).to eq(1)
        end

        run_test!
      end

      response 200, 'Filter by created_at_gteq' do
        before do
          travel_to 2.days.after do
            create(:transaction, user: current_user)
          end
        end

        let(:'q[created_at_gteq]') { 1.day.after }

        schema '$ref': '#/components/schemas/v1/transactions/responses/index'

        it 'returns the correct data length' do
          expect(response_body['data'].size).to eq(1)
        end

        it 'returns a pagination data' do
          expect(response_body['meta']['total']).to eq(1)
        end

        run_test!
      end

      response 200, 'Don not return transactions from other users' do
        before do
          create(:transaction)
        end

        it 'returns the correct data length' do
          expect(response_body['data'].size).to eq(3)
        end

        it 'returns a pagination data' do
          expect(response_body['meta']['total']).to eq(3)
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

    post 'Create Transaction', params: { use_as_request_example: true } do
      tags 'Transactions'
      security [bearer_auth: []]
      consumes 'application/json'
      parameter name: :transaction, in: :body, schema: { '$ref': '#/components/schemas/v1/transactions/requests/create' }

      let(:transaction) { nil }
      let(:Authorization) { authenticated_header({}, current_user)['Authorization'] }

      generate_response_examples

      response 200, 'Successful' do
        let(:category) { create(:category) }

        let(:transaction) { { transaction: transaction_attributes } }
        let(:transaction_attributes) { { name: 'dummy', transaction_type: 1, category_id: category.id, amount: 100 } }

        schema '$ref': '#/components/schemas/v1/transactions/responses/create'

        it 'returns the correct data' do
          expect(response_body['data']['name']).to eq(transaction_attributes[:name])
        end

        it 'returns the correct category' do
          expect(response_body['data']['category']['id']).to eq(category.id)
        end

        run_test!
      end

      response 422, 'Validates errors' do
        let(:transaction) { { transaction: { name: nil } } }

        it 'returns correct error message' do
          expect_error('name', 'blank')
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
  end

  path '/api/v1/transactions/{id}' do
    get 'Show Transaction', params: { use_as_request_example: true } do
      tags 'Transactions'
      security [bearer_auth: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string

      let(:id) { nil }
      let(:Authorization) { authenticated_header({}, current_user)['Authorization'] }

      generate_response_examples

      response 200, 'Successful' do
        let(:id) { create(:transaction, user: current_user).id }

        schema '$ref': '#/components/schemas/v1/transactions/responses/show'

        it 'returns the correct data' do
          expect(response_body['data']['id']).to eq(id)
        end

        run_test!
      end

      response 404, 'Not found for other users' do
        let(:id) { create(:transaction).id }

        it 'returns correct error message' do
          expect_error('base', 'active_record.record_not_found', options: { model: 'Transaction', id: id })
        end

        run_test!
      end

      response 404, 'Not found' do
        let(:id) { 'not_an_id' }

        it 'returns correct error message' do
          expect_error('base', 'active_record.record_not_found', options: { model: 'Transaction', id: id })
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

    put 'Update Transaction', params: { use_as_request_example: true } do
      tags 'Transactions'
      security [bearer_auth: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :body, in: :body, schema: { '$ref': '#/components/schemas/v1/transactions/requests/update' }

      let(:id) { nil }
      let(:body) { nil }
      let(:Authorization) { authenticated_header({}, current_user)['Authorization'] }
      let(:category) { create(:category) }

      generate_response_examples

      response 200, 'Successful' do
        let(:id) { create(:transaction, user: current_user).id }

        let(:body) { { transaction: transaction_attributes } }
        let(:transaction_attributes) { { name: 'dummy', transaction_type: 1, category_id: category.id, amount: 100 } }

        schema '$ref': '#/components/schemas/v1/transactions/responses/update'

        it 'returns the correct data' do
          expect(response_body['data']['name']).to eq(transaction_attributes[:name])
        end

        it 'returns the correct category' do
          expect(response_body['data']['category']['id']).to eq(category.id)
        end

        run_test!
      end

      response 422, 'Validates errors' do
        let(:id) { create(:transaction, user: current_user).id }
        let(:body) { { transaction: { name: nil } } }

        it 'returns correct error message' do
          expect_error('name', 'blank')
        end

        run_test!
      end

      response 404, 'Not found for other users' do
        let(:id) { create(:transaction).id }
        let(:body) { { transaction: { name: 'teste' } } }

        it 'returns correct error message' do
          expect_error('base', 'active_record.record_not_found', options: { model: 'Transaction', id: id })
        end

        run_test!
      end

      response 404, 'Not found' do
        let(:id) { 'not_an_id' }
        let(:body) { { transaction: { name: 'teste' } } }

        it 'returns correct error message' do
          expect_error('base', 'active_record.record_not_found', options: { model: 'Transaction', id: id })
        end

        run_test!
      end

      response 401, 'Unauthorized' do
        let(:Authorization) { nil }
        let(:id) { 'not_an_id' }

        it 'returns correct error message' do
          expect_error('auth', 'unauthenticated', message_key_type: 'devise.failure')
        end

        run_test!
      end
    end

    delete 'Delete Transaction', params: { use_as_request_example: true } do
      tags 'Transactions'
      security [bearer_auth: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string

      let(:id) { nil }
      let(:Authorization) { authenticated_header({}, current_user)['Authorization'] }

      generate_response_examples

      response 200, 'Successful' do
        let(:id) { create(:transaction, user: current_user).id }

        it 'returns correct message' do
          expect(response_body['message']).to eq('Transaction deleted successfully')
        end

        it 'verify if the transaction was deleted' do
          expect { Transaction.find(id) }.to raise_error(ActiveRecord::RecordNotFound)
        end

        run_test!
      end

      response 404, 'Not found for other users' do
        let(:id) { create(:transaction).id }

        it 'returns correct error message' do
          expect_error('base', 'active_record.record_not_found', options: { model: 'Transaction', id: id })
        end

        run_test!
      end

      response 404, 'Not found' do
        let(:id) { 'not_an_id' }

        it 'returns correct error message' do
          expect_error('base', 'active_record.record_not_found', options: { model: 'Transaction', id: id })
        end

        run_test!
      end

      response 401, 'Unauthorized' do
        let(:Authorization) { nil }
        let(:id) { 'not_an_id' }

        it 'returns correct error message' do
          expect_error('auth', 'unauthenticated', message_key_type: 'devise.failure')
        end

        run_test!
      end
    end
  end
end
