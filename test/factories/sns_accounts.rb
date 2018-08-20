# == Schema Information
#
# Table name: sns_accounts
#
#  id            :integer          not null, primary key
#  admin_id      :integer
#  platform      :integer
#  scope         :string(255)
#  union_id      :string(255)
#  openid        :string(255)
#  access_token  :string(255)
#  expires_in    :integer
#  authorized_at :datetime
#  refresh_token :string(255)
#  user_data     :text(65535)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_sns_accounts_on_admin_id  (admin_id)
#  index_sns_accounts_on_openid    (openid)
#  index_sns_accounts_on_union_id  (union_id)
#

FactoryGirl.define do
  factory :sns_account do
    admin_id 1
    platform 1
    scope "MyString"
    union_id "MyString"
    openid "MyString"
    access_token "MyString"
    expires_in 1
    authorized_at "2018-07-29 17:24:01"
    refresh_token "MyString"
    user_data "MyText"
  end
end
