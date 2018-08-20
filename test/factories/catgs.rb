# == Schema Information
#
# Table name: catgs
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  en_name    :string(255)
#  seq        :integer
#  status     :integer
#  ext        :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_catgs_on_name  (name) UNIQUE
#

FactoryGirl.define do
  factory :catg do
    name "MyString"
    en_name "MyString"
    seq 1
    status 1
    ext "MyText"
  end
end
