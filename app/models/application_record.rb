# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  self.implicit_order_column = 'created_at'

  scope :paginate, ->(page, page_size, order) { order(created_at: order).page(page).per(page_size) }

  def default_blueprint
    "#{self.class.name}Serializer".constantize
  end
end
