class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories, id: :uuid do |t|
      t.string :name, null: false
      t.string :description

      t.references :user, type: :uuid, foreign_key: true, null: true

      t.timestamps
    end

    add_index :categories, [:name, :user_id], unique: true
  end
end
