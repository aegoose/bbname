# == Schema Information
#
# Table name: areas
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  code           :string(255)
#  seq            :integer
#  zone           :integer
#  status         :integer
#  parent_id      :integer
#  depth          :integer
#  lft            :integer
#  rgt            :integer
#  children_count :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_areas_on_code       (code)
#  index_areas_on_depth      (depth)
#  index_areas_on_lft        (lft)
#  index_areas_on_name       (name)
#  index_areas_on_parent_id  (parent_id)
#  index_areas_on_rgt        (rgt)
#  index_areas_on_zone       (zone)
#

require 'test_helper'

class AreaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
