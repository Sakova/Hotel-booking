module Queries
  class User < Queries::BaseQuery
    description 'Get user by id (admin only)'

    type Types::UserType, null: true
    argument :id, Integer, required: true

    def resolve(id:)
      raise StandardError unless context[:current_user]&.admin?

      ::User.find(id)
    rescue StandardError
      GraphQL::ExecutionError.new('You should be authenticated as admin to perform this action')
    end
  end
end
