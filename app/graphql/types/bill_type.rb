module Types
  class BillType < Types::BaseObject
    field :id, ID, null: false
    field :price, Integer, null: false
    field :user, UserType, null: false
    field :request, RequestType, null: false
    field :room, RoomType, null: false
  end
end
