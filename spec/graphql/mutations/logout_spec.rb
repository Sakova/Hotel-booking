require 'rails_helper'

RSpec.describe Mutations::SignOutUser, type: :graphql do
  let(:user) { users(:test) }

  it 'log out the user' do
    result = HotelBookingSchema.execute(logout_query, context: { current_user: user, session: { token: '' } })

    expect(result.dig('data', 'signoutUser', 'success')).to be_truthy
  end

  it 'returns an error when no current user' do
    expect do
      HotelBookingSchema.execute(logout_query, context: { current_user: nil, session: { token: '' } })
    end.to raise_error(RuntimeError)
  end

  def logout_query
    <<~GQL
      mutation Logout {
        signoutUser(
          input: {}
        ) {
          success
        }
      }
    GQL
  end
end
