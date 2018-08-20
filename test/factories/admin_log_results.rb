# == Schema Information
#
# Table name: admin_log_results
#
#  id           :integer          not null, primary key
#  pos          :integer
#  row          :text(65535)
#  msg          :text(65535)
#  admin_log_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  level        :integer
#
# Indexes
#
#  index_admin_log_results_on_admin_log_id  (admin_log_id)
#

FactoryGirl.define do
  factory :admin_log_result do
    pos 1
    row "MyText"
    msg "MyText"
    admin_log_id 1
  end
end
