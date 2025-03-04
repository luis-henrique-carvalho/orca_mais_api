# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id          :uuid             not null, primary key
#  description :string
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid
#
# Indexes
#
#  index_categories_on_name_and_user_id  (name,user_id) UNIQUE
#  index_categories_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :category do
    name { Faker::Name.name }
    description { Faker::Lorem.sentence }

    trait :with_user do
      user { association(:user) }
    end
  end
end
