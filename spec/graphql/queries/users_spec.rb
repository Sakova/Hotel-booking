require 'rails_helper'

RSpec.describe Queries::Users, type: :graphql do
  let(:user) { users(:test) }
  let(:admin) { users(:test_admin) }

  it 'returns array of registered users' do
    result = HotelBookingSchema.execute(users_query, context: { current_user: admin })

    expect(result.dig('data', 'users').length).to eq(users.length)
  end

  it 'returns an error when current user is not admin' do
    result = HotelBookingSchema.execute(users_query, context: { current_user: user })

    expect(result.dig('data', 'users')).to be_nil
    expect(result['errors'].first['message']).to eq('You should be authenticated as admin to perform this action')
  end

  def users_query
    <<~GQL
      query {
        users {
          id
          name
          email
        }
      }
    GQL
  end
end
