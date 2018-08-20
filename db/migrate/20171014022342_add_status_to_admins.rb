class AddStatusToAdmins < ActiveRecord::Migration[5.1]
  def change
    add_column :admins, :status, :integer, limit: 2
  end
end
