class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :slug, :cover_image, :updated_at
  belongs_to :user
  belongs_to :category
end
