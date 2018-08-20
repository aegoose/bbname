# == Schema Information
#
# Table name: attachments
#
#  id                  :integer          not null, primary key
#  file_name           :string(255)
#  content_type        :string(255)
#  file_size           :string(255)
#  attachmentable_type :string(255)
#  attachmentable_id   :integer
#  attachment          :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryGirl.define do
  factory :attachment do
    file_name "MyString"
    content_type "MyString"
    file_size "MyString"
    attachmentable_type "MyString"
    attachmentable_id 1
    attachment "MyString"
  end
end
