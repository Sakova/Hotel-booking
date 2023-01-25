require 'rails_helper'

RSpec.describe Queries::Rooms, type: :graphql do
  let(:user) { create(:user, :client) }
  let(:admin) { create(:user, :admin) }

  let(:variables) { {} }
  subject(:query_subject) { HotelBookingSchema.execute(rooms_query, variables: variables, context: ctx) }

  context 'with authenticated admin' do
    let(:ctx) { { current_user: admin } }
    before { create(:room, :small) }

    it 'returns array of rooms' do
      expect(subject.dig('data', 'rooms')[0]).to include('id', 'placesAmount')
    end
  end

  context 'with authenticated user' do
    let(:ctx) { { current_user: user } }
    it 'returns an error' do
      expect(subject.dig('data', 'rooms')).to be_nil
      expect(subject['errors'].first['message']).to eq('You should be auth as admin to perform this action')
    end
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
