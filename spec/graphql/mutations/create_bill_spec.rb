require 'rails_helper'

RSpec.describe Mutations::CreateBill, type: :graphql do
  let(:user) { users(:test) }
  let(:admin) { users(:test_admin) }
  let(:request) { requests(:first_request) }
  let(:room) { rooms(:first_room) }

  it 'creates request returning created request' do
    result = HotelBookingSchema.execute(create_request_query, variables: {
                                          input: { price: room.price.to_i, userId: user.id, requestId: request.id,
                                                   roomId: room.id }
                                        }, context: { current_user: admin })

    expect(result.dig('data', 'createBill', 'user', 'id')).to eq(user.id.to_s)
    expect(result.dig('data', 'createBill', 'request', 'id')).to eq(request.id.to_s)
    expect(result.dig('data', 'createBill', 'room', 'id')).to eq(room.id.to_s)
  end

  it 'returns an error when current user is not admin' do
    expect do
      HotelBookingSchema.execute(create_request_query, variables: {
                                   input: { price: room.price.to_i, userId: user.id, requestId: request.id,
                                            roomId: room.id }
                                 }, context: { current_user: user })
    end.to raise_error(RuntimeError)
  end

  def create_request_query
    <<~GQL
      mutation($input: CreateBillInput!) {
        createBill(
          input: $input
        ) {
          user {
            id
          }
          request {
            id
          }
          room {
            id
          }
        }
      }
    GQL
  end
end
