
# require 'carrierwave/processing/mime_types'
class AttachmentUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  # include CarrierWave::MimeTypes

  FILE_EXTENSION_LIST = %w(csv xls xlsx) #doc docx pdf ppt pptx rar zip 7z
  IMAGE_EXTENSION_LIST = %w(jpg jpeg png gif) # tif tiff
  FILE_EXTENSION_WHITE_LIST = FILE_EXTENSION_LIST + IMAGE_EXTENSION_LIST
  IMAGE_SIZE_LIMIT = [128, 128]

  # process :save_content_type_and_name_and_size_in_model

  def save_content_type_and_name_and_size_in_model
    model.content_type = file.content_type if file.content_type
    model.file_name = original_filename
    model.file_size = file.size
  end

  def extension_white_list
    FILE_EXTENSION_WHITE_LIST
  end

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb, :if => :image? do
    process resize_to_fit: IMAGE_SIZE_LIMIT
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
  protected
  def image?(new_file)
    new_file.content_type.include? 'image'
  end

end
