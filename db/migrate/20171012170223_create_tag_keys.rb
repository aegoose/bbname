class CreateTagKeys < ActiveRecord::Migration[5.1]
  def change
    create_table :tag_keys do |t|
      t.string :name
      t.string :en_name
      t.integer :seq
      t.integer :status, limit: 1
      t.references :catg, foreign_key: true
      t.text :ext

      t.timestamps
    end
    add_index :tag_keys, :name, unique: true
  end
end
