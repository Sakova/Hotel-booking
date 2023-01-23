module Mutations
  class SignOutUser < BaseMutation
    null false
    field :success, Boolean, null: false
    field :message, String, null: true

    def resolve
      return { message: 'There is no authenticated user', success: false } unless context[:current_user]

      context[:session][:token] = nil
      context[:current_user] = nil

      { success: true }
    end
  end
end
