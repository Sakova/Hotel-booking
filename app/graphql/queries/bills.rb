module Queries
  class Bills < Queries::BaseQuery
    description 'List all bills for current user'

    type [Types::BillType], null: true
    def resolve
      raise StandardError unless context[:current_user]

      context[:current_user].bills
    rescue StandardError
      GraphQL::ExecutionError.new('You should be authenticated to perform this action')
    end
  end
end
