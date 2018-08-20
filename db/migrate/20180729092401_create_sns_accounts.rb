class CreateSnsAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :sns_accounts do |t|
      t.integer :admin_id
      t.integer :platform
      t.string :scope
      t.string :union_id
      t.string :openid
      t.string :access_token
      t.integer :expires_in
      t.datetime :authorized_at
      t.string :refresh_token
      t.text :user_data

      t.timestamps
    end
    add_index :sns_accounts, :admin_id
    add_index :sns_accounts, :union_id
    add_index :sns_accounts, :openid
  end
end
