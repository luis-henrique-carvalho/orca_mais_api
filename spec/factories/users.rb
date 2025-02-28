# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  cpf                    :string
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  date_of_birth          :date
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  full_name              :string
#  jti                    :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  phone                  :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  status                 :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_jti                   (jti)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_status                (status)
#
FactoryBot.define do
  factory :user do
    full_name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end
