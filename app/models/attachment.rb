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

class Attachment < ApplicationRecord

  # attr_accessible :attachmentable_id, :attachment, :attachmentable_type, :content_type, :file_name, :file_size, :attachmentable

  mount_uploader :attachment, AttachmentUploader

  belongs_to :attachmentable, :polymorphic => true

  validates :attachmentable, :presence => true
  validates :attachment, :presence => true

  before_save :set_attachment_attributes

  protected
  def set_attachment_attributes
    if attachment.present? && attachment_changed?
      self.content_type = attachment.file.content_type
      self.file_size = attachment.file.size
      self.file_name = attachment.file.original_filename
    end
  end
end
