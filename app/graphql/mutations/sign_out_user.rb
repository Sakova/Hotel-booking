module Mutations
  class SignOutUser < BaseMutation
    null false
    field :success, Boolean, null: false

    def resolve
      raise('There is no auth user') unless context[:current_user]

      context[:session][:token] = nil
      context[:current_user] = nil

      { success: true }
    end
  end
end
