require 'rails_helper'

RSpec.describe Resolvers::BillsFilter, type: :graphql do
  let(:user) { users(:test) }
  let(:admin) { users(:test_admin) }
  let(:bill) { bills(:first_bill) }
  let(:room) { rooms(:first_room) }

  describe 'userId filter' do
    query = <<~GQL
      query($userId: Int) {
        billsFilter(userId: $userId) {
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

        expect(result.dig('data', 'billsFilter')[0]['id']).to eq(bill.id.to_s)
        expect(result.dig('data', 'billsFilter')[0]['user']['id']).to eq(user.id.to_s)
      end
    end

    context 'with authenticated user' do
      it 'returns an error' do
        expect do
          HotelBookingSchema.execute(query, variables: { userId: user.id },
                                            context: { current_user: user })
        end.to raise_error(RuntimeError)
      end
    end
  end

  describe 'roomId filter' do
    query = <<~GQL
      query($roomId: Int) {
        billsFilter(roomId: $roomId) {
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

        expect(result.dig('data', 'billsFilter')[0]['id']).to eq(bill.id.to_s)
        expect(result.dig('data', 'billsFilter')[0]['user']['id']).to eq(user.id.to_s)
      end
    end

    context 'with authenticated user' do
      it 'returns an error' do
        expect do
          HotelBookingSchema.execute(query, variables: { roomId: room.id },
                                            context: { current_user: user })
        end.to raise_error(RuntimeError)
      end
    end
  end

  describe 'order sorting' do
    context 'with authenticated admin' do
      it 'takes OLD order and returning requests sorting by OLD records' do
        query = <<~GQL
          query {
            billsFilter(order: OLD) {
              id
              user {
                id
              }
            }
          }
        GQL

        result = HotelBookingSchema.execute(query, context: { current_user: admin })

        expect(result.dig('data', 'billsFilter')[0]['id']).to eq(bill.id.to_s)
        expect(result.dig('data', 'billsFilter')[0]['user']['id']).to eq(user.id.to_s)
      end

      it 'takes RECENT order and returning requests sorting by RECENT records' do
        query = <<~GQL
          query {
            billsFilter(order: RECENT) {
              id
              user {
                id
              }
            }
          }
        GQL

        result = HotelBookingSchema.execute(query, context: { current_user: admin })

        expect(result.dig('data', 'billsFilter')[0]['id']).to eq(bill.id.to_s)
        expect(result.dig('data', 'billsFilter')[0]['user']['id']).to eq(user.id.to_s)
      end
    end

    context 'with authenticated user' do
      it 'returns an error' do
        query = <<~GQL
          query {
            billsFilter(order: RECENT) {
              id
              user {
                id
              }
            }
          }
        GQL

        expect do
          HotelBookingSchema.execute(query, context: { current_user: user })
        end.to raise_error(RuntimeError)
      end
    end
  end
end
