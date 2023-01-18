require 'rails_helper'

RSpec.describe Mutations::SignInUser, type: :graphql do
  it 'authenticates the user returning a token' do
    result = HotelBookingSchema.execute(login_query, variables: {
                                          input: { credentials: { email: 'test@example.com', password: '123123' } }
                                        }, context: { session: { token: '' } })

    expect(result.dig('data', 'signinUser', 'token')).not_to be_blank
  end

  it 'returns nil when authentications fails' do
    expect do
      HotelBookingSchema.execute(login_query, variables: {
                                   input: { credentials: { email: 'test@example.com', password: 'bad' } }
                                 })
    end.to raise_error(RuntimeError)
  end

  def login_query
    <<~GQL
      mutation Login($input: SignInUserInput!) {
        signinUser(
          input: $input
        ) {
          token
        }
      }
    GQL
  end
end
