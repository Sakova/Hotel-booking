class Room < ApplicationRecord
  has_many :bills, dependent: :nullify

  validates :room_number, uniqueness: true

  ROOM_CLASSES = %i[Room-only Standard Minimalist Deluxe Studio Connecting Standard-suite Junior-suites
                    Presidential-suite Penthouse-suite Honeymoon-suite Bridal-suite].freeze

  enum room_class: ROOM_CLASSES
end
