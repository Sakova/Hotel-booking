module Resolvers
  class BaseResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)
  end
end
