module Types
  class RoomType < Types::BaseObject
    field :id, ID, null: false
    field :places_amount, Integer, null: false
    field :room_class, Integer, null: false
    field :room_number, Integer, null: false
    field :is_free, Boolean, null: false
    field :price, Float, null: false
    field :bills, [BillType], null: true
  end
end
