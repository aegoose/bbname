class CreateAreas < ActiveRecord::Migration[5.1]
  def change
    create_table :areas do |t|
      t.string :name
      t.string :code
      t.integer :seq
      t.integer :zone, limit: 1
      t.integer :status, limit: 1

      t.integer :parent_id
      t.integer :depth # 不能再使用level
      t.integer :lft
      t.integer :rgt
      t.integer :children_count, :default => 0

      t.timestamps
    end
    add_index :areas, :zone
    add_index :areas, :parent_id
    add_index :areas, :depth
    add_index :areas, :lft
    add_index :areas, :rgt
    add_index :areas, :name
    add_index :areas, :code
  end
end
