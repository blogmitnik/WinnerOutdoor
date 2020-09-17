class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :title
      t.text :content
      t.string :slug
      t.references :category
      t.references :user
      t.string :cover_image

      t.timestamps
    end

    add_index :events, :title
    add_index :events, :slug, unique: true
  end
end
