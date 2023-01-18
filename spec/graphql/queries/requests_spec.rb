require 'rails_helper'

RSpec.describe Queries::Requests, type: :graphql do
  let(:user) { users(:test) }
  let(:admin) { users(:test_admin) }

  it 'returns array of requests' do
    result = HotelBookingSchema.execute(requests_query, context: { current_user: admin })

    expect(result.dig('data', 'requests').length).to eq(requests.length)
  end

  it 'returns an error when current user is not admin' do
    result = HotelBookingSchema.execute(requests_query, context: { current_user: user })

    expect(result.dig('data', 'rooms')).to be_nil
    expect(result['errors'].first['message']).to eq('You should be authenticated as admin to perform this action')
  end

  def requests_query
    <<~GQL
      query {
        requests {
          id
          placesAmount
        }
      }
    GQL
  end
end
