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

class Catg < ApplicationRecord
  has_many :tag_keys

  validates :name, :presence => true, :uniqueness => { :case_sensitive => false }
  before_save :set_defaults
  include PingyinParseable
  extend Enumerize
  enumerize :status, :in => {actived:0, disabled:1}, default: :actived

  scope :by_query, ->(query) { where(query) unless query.blank? }
  scope :by_key, -> (qkey) { where('name like :qk or en_name like :qk', qk: "%#{qkey}%") unless qkey.blank? }


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
