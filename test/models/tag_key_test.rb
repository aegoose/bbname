# == Schema Information
#
# Table name: tag_keys
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  en_name    :string(255)
#  seq        :integer
#  status     :integer
#  catg_id    :integer
#  ext        :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tag_keys_on_catg_id  (catg_id)
#  index_tag_keys_on_name     (name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (catg_id => catgs.id)
#

require 'test_helper'

class TagKeyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
