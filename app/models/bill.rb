# == Schema Information
#
# Table name: bills
#
#  id             :bigint           not null, primary key
#  price_cents    :integer          default(0), not null
#  price_currency :string           default("USD"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  request_id     :bigint           not null
#  room_id        :bigint
#  user_id        :bigint           not null
#
# Indexes
#
#  index_bills_on_request_id  (request_id)
#  index_bills_on_room_id     (room_id)
#  index_bills_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (request_id => requests.id)
#  fk_rails_...  (room_id => rooms.id)
#  fk_rails_...  (user_id => users.id)
#
class Bill < ApplicationRecord
  belongs_to :user
  belongs_to :request
  belongs_to :room

  monetize :price_cents
end
