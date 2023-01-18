module Mutations
  class SignInUser < BaseMutation
    null true

    argument :credentials, Types::AuthProviderCredentialsInput, required: false

    field :token, String, null: true
    field :user, Types::UserType, null: true

    def resolve(credentials: nil)
      return unless credentials

      user = User.find_by email: credentials[:email]

      return unless user
      raise 'Invalid email or password' unless user.authenticate(credentials[:password])

      token = JsonWebToken.encode(user_id: user.id)

      context[:session][:token] = token

      { user: user, token: token }
    end
  end
end
