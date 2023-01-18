require 'rails_helper'

RSpec.describe Queries::Rooms, type: :graphql do
  let(:user) { users(:test) }
  let(:admin) { users(:test_admin) }

  it 'returns array of rooms' do
    result = HotelBookingSchema.execute(rooms_query, context: { current_user: admin })

    expect(result.dig('data', 'rooms').length).to eq(rooms.length)
  end

  it 'returns an error when current user is not admin' do
    result = HotelBookingSchema.execute(rooms_query, context: { current_user: user })

    expect(result.dig('data', 'rooms')).to be_nil
    expect(result['errors'].first['message']).to eq('You should be auth as admin to perform this action')
  end

  def rooms_query
    <<~GQL
      query {
        rooms {
          id
          placesAmount
        }
      }
    GQL
  end
end
