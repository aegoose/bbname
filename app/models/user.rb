# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string(255)
#  username               :string(255)
#  phone                  :string(255)
#  status                 :integer
#  role                   :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:login]

  validates :name, presence: true
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, multiline: true, message: :invalid_format
  # validates :phone, uniqueness: { case_sensitive: false, allow_blank: true }
  # validates_format_of :phone, with: /^[0-9\-]*$/, multiline: true, message: :invalid_format

  extend Enumerize
  enumerize :status, in: { deleted: -2, inactive: -1, actived: 0, locked: 1, disabled: 2 }, default: :actived, scope: true
  enumerize :role, in: { visit: -1, normal: 0, vip: 1 }, default: :normal, scope: true

  attr_accessor :login
  # def login=(login)
  #   @login = login
  # end
  # def login
  #   @login || self.username || self.email
  # end
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    # binding.pry
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(['lower(username) = :value OR lower(email) = :value', { :value => login.downcase }]).first
    elsif conditions.key?(:username) || conditions.key?(:email)
      where(conditions.to_h).first
    end
  end
  
end
