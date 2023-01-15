module Types
  class QueryType < Types::BaseObject
    field :users, resolver: Queries::Users
    field :user, resolver: Queries::User
  end
end
