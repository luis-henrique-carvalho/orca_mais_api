# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :kind, null: false
      t.decimal :price, precision: 10, scale: 2
      t.string :customer, null: false

      t.timestamps
    end
  end
end
