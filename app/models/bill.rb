class Bill < ApplicationRecord
  belongs_to :user
  belongs_to :request
  belongs_to :room

  monetize :price_cents
end
