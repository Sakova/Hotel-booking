module Types
  class QueryType < Types::BaseObject
    field :users, resolver: Queries::Users
    field :user, resolver: Queries::User
    field :requests, resolver: Resolvers::RequestsFilter
    field :bills, resolver: Resolvers::BillsFilter
    field :rooms, resolver: Queries::Rooms
  end
end
