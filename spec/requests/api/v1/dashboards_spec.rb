# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Dashboards', type: :request do
  let(:current_user) { create(:user) }

  path '/api/v1/dashboards' do
    get 'List Dashboard', params: { use_as_request_example: true } do
      tags 'Dashboards'
      security [bearer_auth: []]
      consumes 'application/json'

      let(:Authorization) { authenticated_header({}, current_user)['Authorization'] }

      generate_response_examples

      response 200, 'Successful' do
        before do
          travel_to 1.month.ago do
            create_list(:transaction, 3, user: current_user, transaction_type: :income)
          end
        end

        let!(:transactions_income) { current_user.transactions.income }
        let!(:transactions_expense) { create_list(:transaction, 2, user: current_user, transaction_type: :expense) }

        schema '$ref': '#/components/schemas/v1/dashboards/responses/index'

        it 'Returns the correct total_balance' do
          expect(response_body[:total_balance].to_f).to eq((transactions_income.sum(&:amount) + transactions_expense.sum(&:amount)).to_f)
        end

        it 'Returns the correct total_income' do
          expect(response_body[:total_income].to_f).to eq(transactions_income.sum(&:amount).to_f)
        end

        it 'Returns the correct total_expense' do
          expect(response_body[:total_expense].to_f).to eq(transactions_expense.sum(&:amount).to_f)
        end

        it 'Returns the correct incomes_by_category' do
          transaction_categories_name = transactions_income.map(&:category).map(&:name).uniq

          expect(response_body[:incomes_by_category].map { |category| category[:category_name] }).to match_array(transaction_categories_name)
        end

        it 'Returns the correct expenses_by_category' do
          transaction_categories_name = transactions_expense.map(&:category).map(&:name).uniq

          expect(response_body[:expenses_by_category].map { |category| category[:category_name] }).to match_array(transaction_categories_name)
        end

        it 'Returns the correct transactions_by_month count' do
          expect(response_body[:transactions_by_month].count).to eq(2)
        end

        it 'Returns the correct transactions_by_month' do
          expect(response_body[:transactions_by_month].map { |transaction| transaction[:total_amount].to_f }).to contain_exactly(transactions_income.sum(&:amount).to_f, transactions_expense.sum(&:amount).to_f)
        end

        run_test!
      end

      response 401, 'Unauthorized' do
        let(:Authorization) { nil }

        run_test!
      end
    end
  end
end
