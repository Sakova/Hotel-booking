module Queries
  class Users < Queries::BaseQuery
    description 'List all Users (admin only)'

    type [Types::UserType], null: true
    def resolve
      return unless context[:current_user]&.admin?

      ::User.all
    end
  end
end
