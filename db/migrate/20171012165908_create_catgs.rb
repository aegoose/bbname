class CreateCatgs < ActiveRecord::Migration[5.1]
  def change
    create_table :catgs do |t|
      t.string :name
      t.string :en_name
      t.integer :seq
      t.integer :status, limit: 1
      t.text :ext

      t.timestamps
    end
    add_index :catgs, :name, unique: true
  end
end
