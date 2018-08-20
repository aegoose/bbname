class AddContactsToAdmins < ActiveRecord::Migration[5.1]
  def change
    add_column :admins, :phone, :string
    add_column :admins, :tel, :string
    add_column :admins, :qq, :string
    add_column :admins, :fax, :string
    add_column :admins, :desc, :text
    add_index :admins, :phone
  end
end
