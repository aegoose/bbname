# == Schema Information
#
# Table name: admins
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
#  status                 :integer
#  role                   :integer
#  phone                  :string(255)
#  tel                    :string(255)
#  qq                     :string(255)
#  fax                    :string(255)
#  desc                   :text(65535)
#  sns_id                 :integer
#
# Indexes
#
#  index_admins_on_email                 (email) UNIQUE
#  index_admins_on_phone                 (phone)
#  index_admins_on_reset_password_token  (reset_password_token) UNIQUE
#  index_admins_on_username              (username) UNIQUE
#

class Admin < ApplicationRecord

  second_level_cache expires_in: 1.week

  # admin.second_level_cache_key  # We will get the key looks like "slc/user/1/0"
  # admin.expire_second_level_cache
  # admin.without_second_level_cache do end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:login]

  validates :name, presence: true
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, multiline: true, message: :invalid_format
  validates :phone, uniqueness: { case_sensitive: false, allow_blank: true }
  validates_format_of :phone, with: /^[0-9\-]*$/, multiline: true, message: :invalid_format

  include PingyinParseable
  extend Enumerize
  enumerize :status, in: { deleted: -2, inactive: -1, actived: 0, locked: 1, disabled: 2 }, default: :actived, scope: true
  enumerize :role, in: { visit: -1, normal: 0, manager: 1, mayor: 2, admin: 3, super: 9 }, default: :manager, scope: true

  scope :by_query, ->(query) { where(query) unless query.blank? }
  scope :by_key, -> (qkey) { where('name like :qk or username like :qk or email like :qk', qk: "%#{qkey}%") unless qkey.blank? }

  scope :business_amdins, -> { where('role < ?', Admin.role.mayor.value) }
  scope :all_managers, -> { with_role(:manager) }

  attr_accessor :login, :org_role
  # def login=(login)
  #   @login = login
  # end
  def login
    @login || self.username || self.email
  end

  ################################################
  # 角色权限
  ################################################

  # 普通访问者
  def visitor?
    role.blank? || role.visit?
  end

  # 产品经理
  def manager?
    role&.manager?
  end

  # 网点管理员
  def mayor?
    role&.mayor?
  end

  # 镇区管理员(总部的管理员)
  def admin?
    role && role.admin? # || role.super?
  end

  # 超级管理员
  def super?
    role&.super?
  end

  # 检查指定用户是否可以编辑
  def editable?(ckadmin)
    #超级管理员无法将自己将级
    return false if super? && id == ckadmin.id && !ckadmin.super?
    #管理员升级超过当前的角色
    role.value >= ckadmin.role.value
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    # binding.pry
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(['lower(username) = :value OR lower(email) = :value', { :value => login.downcase }]).first
    elsif conditions.key?(:username) || conditions.key?(:email)
      where(conditions.to_h).first
    end
  end

  def self.role_options
    self.role.options.reject {|x| x[1]=='visit' || x[1]=='normal' }
  end

  # def self.find_first_by_auth_conditions(warden_conditions)
  #   conditions = warden_conditions.dup
  #   binding.pry
  #   if login = conditions.delete(:login)
  #     where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
  #   else
  #     if conditions[:username].nil?
  #       where(conditions).first
  #     else
  #       where(username: conditions[:username]).first
  #     end
  #   end
  # end

end
