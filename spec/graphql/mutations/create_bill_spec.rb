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
    it 'creates bill returning created bill' do
      p subject
      expect(subject.dig('data', 'createBill', 'bill', 'user', 'id')).to eq(user.id.to_s)
      expect(subject.dig('data', 'createBill', 'bill', 'request', 'id')).to eq(request.id.to_s)
      expect(subject.dig('data', 'createBill', 'bill', 'room', 'id')).to eq(room.id.to_s)
    end
  end

  context 'with authenticated user' do
    let(:ctx) { { current_user: user } }
    it 'returns message when current user is not admin' do
      p subject
      expect(subject.dig('data', 'createBill', 'message')).to eq('You do not have permission to perform this action')
    end
  end

  def create_request_query
    <<~GQL
      mutation ($input: CreateBillInput!) {
        createBill(input: $input) {
          message
          bill {
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
      }
    GQL
  end
end
