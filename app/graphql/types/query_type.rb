module Types
  class QueryType < Types::BaseObject
    field :users, resolver: Queries::Users
    field :user, resolver: Queries::User
    field :requests, resolver: Queries::Requests
    field :requests_filter, resolver: Resolvers::RequestsFilter
    field :bills, resolver: Queries::Bills
    field :bills_filter, resolver: Resolvers::BillsFilter
    field :rooms, resolver: Queries::Rooms
  end
end
