# frozen_string_literal: true

user = User.find_or_create_by!(email: 't@t.com') do |user|
  user.password = '123456'
  user.full_name = 'Teste'
end

%w[Investimentos Poupança Despesas Renda Empréstimos Seguros Impostos
   Aposentadoria Alimentação Transporte Moradia Saúde Educação Lazer
   Salário Freelance].each do |nome_categoria|
  Category.find_or_create_by!(name: nome_categoria)
end
require 'date'

start_date = Date.today << 6 # 2 years ago
end_date = Date.today

transactions = []

(start_date..end_date).select { |d| d.day == 1 }.each do |date|
  3.times do
    FactoryBot.create(:transaction, user: User.last, category: Category.all.sample, created_at: date, amount: rand(1000..10000))
  end
end
