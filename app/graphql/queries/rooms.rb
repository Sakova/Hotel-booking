module Queries
  class Rooms < Queries::BaseQuery
    description 'List all rooms (admin only)'

    type [Types::RoomType], null: true
    def resolve
      raise StandardError unless context[:current_user]&.admin?

      ::Room.all
    rescue StandardError
      GraphQL::ExecutionError.new('You should be auth as admin to perform this action')
    end
  end
end
