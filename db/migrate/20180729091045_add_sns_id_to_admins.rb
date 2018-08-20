class AddSnsIdToAdmins < ActiveRecord::Migration[5.1]
  def change
    add_column :admins, :sns_id, :integer
  end
end
