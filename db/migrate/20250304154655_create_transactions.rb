class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions, id: :uuid do |t|
      t.string :name, null: false
      t.decimal :amount, precision: 12, scale: 3, null: false
      t.integer :transaction_type, null: false, default: 0
      t.string :description

      t.references :category, type: :uuid, null: false, foreign_key: true
      t.references :user, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end

    add_index :transactions, :name, unique: true
  end
end
