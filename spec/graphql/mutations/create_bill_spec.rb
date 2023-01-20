require 'rails_helper'

RSpec.describe Mutations::CreateBill, type: :graphql do
  let(:user) { users(:test) }
  let(:admin) { users(:test_admin) }
  let(:request) { requests(:first_request) }
  let(:room) { rooms(:first_room) }

  let(:variables) do
    {
      input: { price: room.price.to_i, userId: user.id, requestId: request.id,
               roomId: room.id }
    }
  end
  subject(:query_subject) { HotelBookingSchema.execute(create_request_query, variables: variables, context: ctx) }

  context 'with authenticated admin' do
    let(:ctx) { { current_user: admin } }
    it 'creates request returning created request' do
      expect(subject.dig('data', 'createBill', 'user', 'id')).to eq(user.id.to_s)
      expect(subject.dig('data', 'createBill', 'request', 'id')).to eq(request.id.to_s)
      expect(subject.dig('data', 'createBill', 'room', 'id')).to eq(room.id.to_s)
    end
  end

  context 'with authenticated user' do
    let(:ctx) { { current_user: user } }
    it 'returns an error when current user is not admin' do
      expect{ subject }.to raise_error(RuntimeError)
    end
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
