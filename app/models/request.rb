class Request < ApplicationRecord
  belongs_to :user
  has_one :bill, dependent: :destroy

  enum room_class: ROOM_CLASSES
end
