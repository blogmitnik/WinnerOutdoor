class Event < ApplicationRecord
	extend FriendlyId
	friendly_id :title, use: :slugged

	belongs_to :user
	belongs_to :category

	validates :title, :content, :category_id, :user_id, presence: true
end
