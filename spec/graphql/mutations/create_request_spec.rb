require 'rails_helper'

RSpec.describe Mutations::CreateRequest, type: :graphql do
  let(:user) { users(:test) }

  it 'creates request returning created request' do
    result = HotelBookingSchema.execute(create_request_query, variables: {
                                          input: { placesAmount: 2, roomClass: 3,
                                                   stayTimeFrom: (DateTime.now + 1).iso8601,
                                                   stayTimeTo: (DateTime.now + 2).iso8601,
                                                   comment: 'I need two swimming pools in each room' }
                                        }, context: { current_user: user })

    expect(result.dig('data', 'createRequest', 'roomClass')).to eq('Deluxe')
    expect(result.dig('data', 'createRequest', 'comment')).to eq('I need two swimming pools in each room')
  end

  it 'returns an error when authentications fails' do
    result = HotelBookingSchema.execute(create_request_query, variables: {
                                          input: { placesAmount: nil, roomClass: 3,
                                                   stayTimeFrom: nil,
                                                   stayTimeTo: (DateTime.now + 2).iso8601,
                                                   comment: 'I need two swimming pools in each room' }
                                        }, context: { current_user: user })

    expect(result['errors'].first['message']).to include('Expected value to not be null')
    expect(result.dig('data', 'createRequest')).to be_nil
  end

  def create_request_query
    <<~GQL
      mutation($input: CreateRequestInput!) {
        createRequest(
          input: $input
        ) {
          roomClass
          comment
        }
      }
    GQL
  end
end
