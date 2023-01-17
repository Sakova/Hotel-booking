module Queries
  class Users < Queries::BaseQuery
    description 'List all Users (admin only)'

    type [Types::UserType], null: true
    def resolve
      raise StandardError unless context[:current_user]&.admin?

      ::User.all
    rescue StandardError
      GraphQL::ExecutionError.new('You should be authenticated as admin to perform this action')
    end
  end
end
