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
class Category < ApplicationRecord
  include PgSearch::Model

  belongs_to :user, optional: true

  has_many :transactions, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { scope: :user_id }

  pg_search_scope :search, against: :name, using: {
    tsearch: { prefix: true }
  }

  scope :by_user_or_global, ->(user_id) { where(user_id: [nil, user_id]) }
end
