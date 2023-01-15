module Queries
  class User < Queries::BaseQuery
    description 'Get user by id (admin only)'

    type Types::UserType, null: true
    argument :id, Integer, required: true

    def resolve(id:)
      return unless context[:current_user]&.admin?

      ::User.find(id)
    end
  end
end
