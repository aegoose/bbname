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

class TagKey < ApplicationRecord
  belongs_to :catg

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :catg_id, :presence => true
  before_save :set_defaults

  extend Enumerize
  enumerize :status, :in => {actived:0, disabled:1}, default: :actived
  include PingyinParseable

  scope :by_query, ->(query) { where(query) unless query.blank? }
  scope :by_key, -> (qkey) { where('name like :qk or en_name like :qk', qk: "%#{qkey}%") unless qkey.blank? }

  scope :by_catg, ->(cid) { where(catg_id: cid) }
  scope :random, ->(lm) { order('RAND()').limit(lm)}

  def set_defaults
    if en_name.blank?
      self.en_name = word_to_pingyin(self.name)
    end

    if seq.blank? || seq <= 0
      seq = self.class.maximum(:seq) || 0
      self.seq = seq + 1
    end
  end



end
