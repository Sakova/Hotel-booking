require 'rails_helper'

RSpec.describe Queries::User, type: :graphql do
  let(:user) { users(:test) }
  let(:admin) { users(:test_admin) }

  it 'returns info about the current logged in user' do
    result = HotelBookingSchema.execute(user_query, variables: { id: user.id }, context: { current_user: admin })

    expect(result.dig('data', 'user', 'id')).to eq(user.id.to_s)
    expect(result.dig('data', 'user', 'name')).to eq(user.name)
    expect(result.dig('data', 'user', 'email')).to eq(user.email)
  end

  it 'returns an error when current user is not admin' do
    result = HotelBookingSchema.execute(user_query, variables: { id: user.id }, context: { current_user: user })

    expect(result.dig('data', 'user')).to be_nil
    expect(result['errors'].first['message']).to eq('You should be authenticated as admin to perform this action')
  end

  def user_query
    <<~GQL
      query($id: Int!) {
        user(id: $id) {
          id
          name
          email
        }
      }
    GQL
  end
end
