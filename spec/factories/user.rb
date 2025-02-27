FactoryBot.define do
    factory :users do
        name { Faker::Name.name }
        email { Faker::Internet.email }
    end
end
