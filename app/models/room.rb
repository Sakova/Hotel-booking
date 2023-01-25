# == Schema Information
#
# Table name: rooms
#
#  id            :bigint           not null, primary key
#  is_free       :boolean          default(TRUE), not null
#  places_amount :integer          default(1), not null
#  price         :decimal(10, 2)   not null
#  room_class    :integer          default("Room-only"), not null
#  room_number   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_rooms_on_price        (price)
#  index_rooms_on_room_number  (room_number) UNIQUE
#
class Room < ApplicationRecord
  has_many :bills, dependent: :nullify

  validates :room_number, uniqueness: true

  ROOM_CLASSES = %i[Room-only Standard Minimalist Deluxe Studio Connecting Standard-suite Junior-suites
                    Presidential-suite Penthouse-suite Honeymoon-suite Bridal-suite].freeze

  enum room_class: ROOM_CLASSES
end
