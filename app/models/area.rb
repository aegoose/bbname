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

class Area < ApplicationRecord
  second_level_cache expires_in: 1.week #second_level_cache

  validates :name, :presence => true

  before_save :set_defaults
  include PingyinParseable
  acts_as_nested_set order_column: :seq, counter_cache: :children_count

  extend Enumerize
  enumerize :status, :in => {actived: 0, disabled: 1}, default: :actived, scope: true
  enumerize :zone, :in => {country: 0, province: 1, city: 2, county: 3}, default: :city, scope: true

  scope :by_query, ->(query) { where(query) unless query.blank? }
  scope :by_key, -> (qkey) { where('name like :qk or code like :qk', qk: "%#{qkey}%") unless qkey.blank? }

  # scope :dg_city, -> {find(id: 441900) } # 东莞市
  scope :dg_distincts, -> {where(parent_id: 441900) } # 东莞市的所有区
  scope :gz_cities, -> { where(id: [440100,440600]) } # 广州佛山
  scope :gz_distincts, -> { where(parent_id: [440100,440600]) } # 广州佛山的地区
  # 440100 440600

  # :before_add     => :do_before_add_stuff,
  # :after_add      => :do_after_add_stuff,
  # :before_remove  => :do_before_remove_stuff,
  # after_remove :rebuild_slug,
  # around_move :da_fancy_things_around
  #
  def self.dg_city
    find_by_id(441900)
  end

  def set_defaults
    if code.blank?
      self.code = word_to_pingyin(self.name)
    end

    # if seq.blank? || seq <= 0
    #   seq = self.class.maximum(:seq) || 0
    #   self.seq = seq + 1
    # end
  end

end
