class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :events_count, null: false, default: 0

      t.timestamps
    end

    add_index :categories, :name
  end
end
