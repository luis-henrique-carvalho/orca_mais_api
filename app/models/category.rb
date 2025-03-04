# == Schema Information
#
# Table name: categories
#
#  id          :uuid             not null, primary key
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Category < ApplicationRecord
    has_many :transactions

    validates :name, presence: true
end
