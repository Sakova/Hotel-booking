require 'rails_helper'

RSpec.describe Resolvers::BillsFilter, type: :graphql do
  let(:user) { users(:test) }
  let(:admin) { users(:test_admin) }
  let(:bill) { bills(:first_bill) }
  let(:high_price_bill) { bills(:third_bill) }
  let(:room) { rooms(:first_room) }

  let(:variables) { {} }
  subject(:query_result) { HotelBookingSchema.execute(query, variables: variables, context: ctx) }

  describe 'userId filter' do
    let(:query) { <<~GQL }
      query($userId: Int) {
        bills(userId: $userId) {
          id
          user {
            id
          }
        }
      }
    GQL
    let(:variables) { { userId: user.id } }

    context 'with authenticated admin' do
      let(:ctx) { { current_user: admin } }
      it 'takes user id and returning bills by user id' do
        expect(subject.dig('data', 'bills')[0]['id']).to eq(bill.id.to_s)
        expect(subject.dig('data', 'bills')[0]['user']['id']).to eq(user.id.to_s)
      end
    end

    context 'with authenticated user' do
      let(:ctx) { { current_user: user } }
      it 'takes user id and returning bills by user id' do
        expect(subject.dig('data', 'bills')[0]['id']).to eq(bill.id.to_s)
        expect(subject.dig('data', 'bills')[0]['user']['id']).to eq(user.id.to_s)
      end
    end
  end

  describe 'roomId filter' do
    let(:query) { <<~GQL }
      query($roomId: Int) {
        bills(roomId: $roomId) {
          id
          user {
            id
          }
        }
      }
    GQL
    let(:variables) { { roomId: room.id } }

    context 'with authenticated admin' do
      let(:ctx) { { current_user: admin } }
      it 'takes room id and returning bills by room id' do
        expect(subject.dig('data', 'bills')[0]['id']).to eq(bill.id.to_s)
        expect(subject.dig('data', 'bills')[0]['user']['id']).to eq(user.id.to_s)
      end
    end

    context 'with authenticated user' do
      let(:ctx) { { current_user: user } }
      it 'returns an error' do
        expect(subject['errors'].first['message']).to eq('You need to authenticate as admin to perform this action')
      end
    end
  end

  describe 'order sorting' do
    context 'with authenticated admin' do
      let(:ctx) { { current_user: admin } }
      context 'with DESC order' do
        let(:query) { <<~GQL }
          query {
            bills(order: [{createdAt: DESC}]) {
              id
              user {
                id
              }
            }
          }
        GQL
        it 'returns bills sorting by created_at field' do
          expect(subject.dig('data', 'bills')[0]['id']).to eq(bill.id.to_s)
          expect(subject.dig('data', 'bills')[0]['user']['id']).to eq(user.id.to_s)
        end
      end

      context 'with ASC order' do
        let(:query) { <<~GQL }
          query {
            bills(order: [{createdAt: ASC}]) {
              id
              user {
                id
              }
            }
          }
        GQL
        it 'returns bills sorting by created_at field' do
          expect(subject.dig('data', 'bills')[0]['id']).to eq(bill.id.to_s)
          expect(subject.dig('data', 'bills')[0]['user']['id']).to eq(user.id.to_s)
        end
      end

      context 'with DESC order' do
        let(:query) { <<~GQL }
          query {
            bills(order: [{priceCents: DESC}]) {
              id
              user {
                id
              }
            }
          }
        GQL
        it 'returns bills sorting by price_cents field' do
          expect(subject.dig('data', 'bills')[0]['id']).to eq(high_price_bill.id.to_s)
          expect(subject.dig('data', 'bills')[0]['user']['id']).to eq(user.id.to_s)
        end
      end

      context 'with ASC order' do
        let(:query) { <<~GQL }
          query {
            bills(order: [{priceCents: ASC}]) {
              id
              user {
                id
              }
            }
          }
        GQL
        it 'returns bills sorting by price_cents field' do
          expect(subject.dig('data', 'bills')[0]['id']).to eq(bill.id.to_s)
          expect(subject.dig('data', 'bills')[0]['user']['id']).to eq(user.id.to_s)
        end
      end
    end

    context 'with authenticated user' do
      let(:ctx) { { current_user: user } }
      let(:query) { <<~GQL }
        query {
          bills(order: [{createdAt: ASC}]) {
            id
            user {
              id
            }
          }
        }
      GQL
      it 'returns an error' do
        expect(subject['errors'].first['message']).to eq('You need to authenticate as admin to perform this action')
      end
    end
  end
end
