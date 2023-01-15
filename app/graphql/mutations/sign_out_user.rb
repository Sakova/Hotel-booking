module Mutations
  class SignOutUser < BaseMutation
    null true

    def resolve
      return unless context[:current_user]

      context[:session][:token] = nil
      context[:current_user] = nil
    end
  end
end
