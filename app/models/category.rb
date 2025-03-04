# frozen_string_literal: true

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
  include PgSearch::Model

  has_many :transactions, dependent: :restrict_with_error

  validates :name, presence: true

  pg_search_scope :search, against: :name, using: {
    tsearch: { prefix: true }
  }
end
