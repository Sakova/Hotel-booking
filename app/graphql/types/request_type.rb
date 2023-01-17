module Types
  class RequestType < Types::BaseObject
    field :id, ID, null: false
    field :places_amount, Integer, null: false
    field :room_class, String, null: false
    field :stay_time_from, GraphQL::Types::ISO8601DateTime, null: false
    field :stay_time_to, GraphQL::Types::ISO8601DateTime, null: false
    field :comment, String, null: false
    field :user, UserType, null: false
    field :bill, BillType, null: true
  end
end
