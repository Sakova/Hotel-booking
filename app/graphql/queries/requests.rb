module Queries
  class Requests < Queries::BaseQuery
    description 'List all Requests (admin only)'

    type [Types::RequestType], null: true
    def resolve
      raise StandardError unless context[:current_user]&.admin?

      ::Request.all
    rescue StandardError
      GraphQL::ExecutionError.new('You should be authenticated as admin to perform this action')
    end
  end
end
