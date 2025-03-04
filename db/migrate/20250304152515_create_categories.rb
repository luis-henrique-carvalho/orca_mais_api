class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories, id: :uuid do |t|
      t.string :name, null: false
      t.string :description

      t.timestamps
    end

    add_index :categories, :name, unique: true
  end
end
