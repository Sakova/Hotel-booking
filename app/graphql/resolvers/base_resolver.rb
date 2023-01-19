module Resolvers
  class BaseResolver < GraphQL::Schema::Resolver
    include SearchObject.module(:graphql)

    def check_authentication!
      return true if context[:current_user]

      raise GraphQL::ExecutionError,
            'You need to authenticate to perform this action'
    end

    def check_admin!
      return true if context[:current_user]&.admin?

      raise GraphQL::ExecutionError,
            'You need to authenticate as admin to perform this action'
    end

    def check_client!
      return true if context[:current_user]&.client?

      raise GraphQL::ExecutionError,
            'You need to authenticate as client to perform this action'
    end
  end
end
