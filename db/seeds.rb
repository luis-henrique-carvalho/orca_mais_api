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

transactions = [
  { description: 'Salário', amount: 5000, category: Category.find_by(name: 'Salário'), transaction_type: :income, name: 'Salário' },
  { description: 'Aluguel', amount: 1000, category: Category.find_by(name: 'Moradia'), transaction_type: :expense, name: 'Aluguel' },
  { description: 'Mercado', amount: 500, category: Category.find_by(name: 'Alimentação'), transaction_type: :expense, name: 'Mercado' },
  { description: 'Uber', amount: 50, category: Category.find_by(name: 'Transporte'), transaction_type: :expense, name: 'Uber' },
  { description: 'Netflix', amount: 30, category: Category.find_by(name: 'Lazer'), transaction_type: :expense, name: 'Netflix' },
  { description: 'Poupança', amount: 1000, category: Category.find_by(name: 'Poupança'), transaction_type: :income, name: 'Poupança' },
  { description: 'Investimento', amount: 500, category: Category.find_by(name: 'Investimentos'), transaction_type: :income, name: 'Investimento' },
  { description: 'Imposto de Renda', amount: 500, category: Category.find_by(name: 'Impostos'), transaction_type: :expense, name: 'Imposto de Renda' },
  { description: 'Plano de Saúde', amount: 300, category: Category.find_by(name: 'Saúde'), transaction_type: :expense, name: 'Plano de Saúde' },
  { description: 'Faculdade', amount: 500, category: Category.find_by(name: 'Educação'), transaction_type: :expense, name: 'Faculdade' },
  { description: 'Freelance', amount: 1000, category: Category.find_by(name: 'Freelance'), transaction_type: :income, name: 'Freelance' },
  { description: 'Seguro de Vida', amount: 200, category: Category.find_by(name: 'Seguros'), transaction_type: :expense, name: 'Seguro de Vida' },
  { description: 'Aposentadoria', amount: 1000, category: Category.find_by(name: 'Aposentadoria'), transaction_type: :income, name: 'Aposentadoria' },
  { description: 'Empréstimo', amount: 500, category: Category.find_by(name: 'Empréstimos'), transaction_type: :income, name: 'Empréstimo' }
]

transactions.each do |transaction|
  user.transactions.find_or_create_by!(transaction)
end
