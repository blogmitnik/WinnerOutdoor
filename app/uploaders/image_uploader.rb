class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def asset_host
    return ENV['SITE_URL']
  end

  def default_url
    "#{asset_host}#{ActionController::Base.helpers.asset_path("default_event_cover.png")}"
  end

  # For crop and scale images
  # [Usage] event.cover_image.recreate_versions!(:thumb)
  version :thumb do
    process resize_to_fill: [360, 360]
    def default_url
      "#{asset_host}#{ActionController::Base.helpers.asset_path("default_event_cover_thumb.png")}"
    end
  end

  version :small_thumb, from_version: :thumb do
    process resize_to_fill: [85, 85]
    def default_url
      "#{asset_host}#{ActionController::Base.helpers.asset_path("default_event_cover_small.png")}"
    end
  end

  # Add validations to whitelist .png, .jpg and .gif extensions
  def extension_whitelist
    %w(jpg jpeg png)
  end

  # Add content type checks
  def content_type_whitelist
    /image\//
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
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

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
end
