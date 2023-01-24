# == Schema Information
#
# Table name: requests
#
#  id             :bigint           not null, primary key
#  comment        :text
#  places_amount  :integer          not null
#  room_class     :integer          default("Room-only"), not null
#  stay_time_from :datetime         not null
#  stay_time_to   :datetime         not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_requests_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Request < ApplicationRecord
  belongs_to :user
  has_one :bill, dependent: :destroy

  enum room_class: Room::ROOM_CLASSES
end
