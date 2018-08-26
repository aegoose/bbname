class AddBasicAttrToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :name, :string
    add_column :users, :username, :string
    add_index :users, :username, unique: true
    add_column :users, :phone, :string
    add_column :users, :status, :integer, limit: 2
    add_column :users, :role, :integer
  end
end
