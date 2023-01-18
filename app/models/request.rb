class Request < ApplicationRecord
  belongs_to :user
  has_one :bill, dependent: :destroy

  enum room_class: Room::ROOM_CLASSES
end
