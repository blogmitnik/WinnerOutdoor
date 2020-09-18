class Event < ApplicationRecord
	extend FriendlyId
	friendly_id :title, use: :slugged

	belongs_to :user
	belongs_to :category
	has_many :line_items, inverse_of: :order

	validates :title, :content, :category, :user, presence: true
	validates :cover_image, file_size: { less_than: 2.megabytes }

	paginates_per 3

	self.implicit_order_column = "updated_at"

	mount_uploader :cover_image, ImageUploader
end
