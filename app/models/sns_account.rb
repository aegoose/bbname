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

class SnsAccount < ApplicationRecord

  extend Enumerize
  enumerize :platform, in: { unkonw: 0, account: 1, phone: 2, wx_pub: 4, wx_lite: 8 }, default: :wx_pub
  belongs_to :admin, optional: true

  def valid_refresh_token?
    (authorized_at - Time.now).to_i < expires_in
  end
end
