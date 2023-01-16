module Types
  class MutationType < Types::BaseObject
    field :create_user, mutation: Mutations::CreateUser
    field :signin_user, mutation: Mutations::SignInUser
    field :signout_user, mutation: Mutations::SignOutUser
    field :create_request, mutation: Mutations::CreateRequest
  end
end
