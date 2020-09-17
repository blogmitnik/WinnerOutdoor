class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :events_count

  has_many :events
end
