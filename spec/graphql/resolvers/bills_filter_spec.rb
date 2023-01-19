require 'rails_helper'

RSpec.describe Resolvers::BillsFilter, type: :graphql do
  let(:user) { users(:test) }
  let(:admin) { users(:test_admin) }
  let(:bill) { bills(:first_bill) }
  let(:high_price_bill) { bills(:third_bill) }
  let(:room) { rooms(:first_room) }

  describe 'userId filter' do
    query = <<~GQL
      query($userId: Int) {
        bills(userId: $userId) {
          id
          user {
            id
          }
        }
      }
    GQL

    context 'with authenticated admin' do
      it 'takes user id and returning bills by user id' do

        result = HotelBookingSchema.execute(query, variables: { userId: user.id },
                                                   context: { current_user: admin })

        expect(result.dig('data', 'bills')[0]['id']).to eq(bill.id.to_s)
        expect(result.dig('data', 'bills')[0]['user']['id']).to eq(user.id.to_s)
      end
    end

    context 'with authenticated user' do
      it 'takes user id and returning bills by user id' do
        result = HotelBookingSchema.execute(query, variables: { userId: user.id },
                                                   context: { current_user: admin })

        expect(result.dig('data', 'bills')[0]['id']).to eq(bill.id.to_s)
        expect(result.dig('data', 'bills')[0]['user']['id']).to eq(user.id.to_s)
      end
    end
  end

  describe 'roomId filter' do
    query = <<~GQL
      query($roomId: Int) {
        bills(roomId: $roomId) {
          id
          user {
            id
          }
        }
      }
    GQL

    context 'with authenticated admin' do
      it 'takes room id and returning bills by room id' do

        result = HotelBookingSchema.execute(query, variables: { roomId: room.id },
                                                   context: { current_user: admin })

        expect(result.dig('data', 'bills')[0]['id']).to eq(bill.id.to_s)
        expect(result.dig('data', 'bills')[0]['user']['id']).to eq(user.id.to_s)
      end
    end

    context 'with authenticated user' do
      it 'returns an error' do
        result = HotelBookingSchema.execute(query, variables: { roomId: room.id },
                                                   context: { current_user: user })

        expect(result['errors'].first['message']).to eq('You need to authenticate as admin to perform this action')
      end
    end
  end

  describe 'order sorting' do
    context 'with authenticated admin' do
      query = <<~GQL
        query($order: [String!]) {
          bills(order: $order) {
            id
            user {
              id
            }
          }
        }
      GQL

      it 'takes OLD order and returning requests sorting by OLD records' do
        result = HotelBookingSchema.execute(query, variables: { order: 'HIGH_PRICE' },
                                                   context: { current_user: admin })

        expect(result.dig('data', 'bills')[0]['id']).to eq(high_price_bill.id.to_s)
        expect(result.dig('data', 'bills')[0]['user']['id']).to eq(user.id.to_s)
      end

      it 'takes RECENT order and returning requests sorting by RECENT records' do
        result = HotelBookingSchema.execute(query, variables: { order: 'RECENT' },
                                                   context: { current_user: admin })

        expect(result.dig('data', 'bills')[0]['id']).to eq(bill.id.to_s)
        expect(result.dig('data', 'bills')[0]['user']['id']).to eq(user.id.to_s)
      end

      it 'takes HIGH_PRICE order and returning requests sorting by HIGH PRICE records' do
        result = HotelBookingSchema.execute(query, variables: { order: 'HIGH_PRICE' },
                                                   context: { current_user: admin })

        expect(result.dig('data', 'bills')[0]['id']).to eq(high_price_bill.id.to_s)
        expect(result.dig('data', 'bills')[0]['user']['id']).to eq(user.id.to_s)
      end

      it 'takes LOW_PRICE order and returning requests sorting by LOW PRICE records' do
        result = HotelBookingSchema.execute(query, variables: { order: 'LOW_PRICE' },
                                                   context: { current_user: admin })

        expect(result.dig('data', 'bills')[0]['id']).to eq(bill.id.to_s)
        expect(result.dig('data', 'bills')[0]['user']['id']).to eq(user.id.to_s)
      end
    end

    context 'with authenticated user' do
      it 'returns an error' do
        query = <<~GQL
          query {
            bills(order: "RECENT") {
              id
              user {
                id
              }
            }
          }
        GQL

        result = HotelBookingSchema.execute(query, context: { current_user: user })

        expect(result['errors'].first['message']).to eq('You need to authenticate as admin to perform this action')
      end
    end
  end
end
