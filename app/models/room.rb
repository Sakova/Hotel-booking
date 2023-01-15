class Room < ApplicationRecord
  has_many :bills, dependent: :destroy

  validates :room_number, uniqueness: true

  enum room_class: ROOM_CLASSES
end
