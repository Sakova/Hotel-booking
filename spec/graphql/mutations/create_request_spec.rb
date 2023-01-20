require 'rails_helper'

RSpec.describe Mutations::CreateRequest, type: :graphql do
  let(:user) { users(:test) }

  subject(:query_subject) { HotelBookingSchema.execute(create_request_query, variables: variables, context: ctx) }

  context 'with authenticated user' do
    let(:ctx) { { current_user: user } }
    context 'with valid data' do
      let(:variables) do
        {
          input: { placesAmount: 2, roomClass: 3,
                   stayTimeFrom: (DateTime.now + 1).iso8601,
                   stayTimeTo: (DateTime.now + 2).iso8601,
                   comment: 'I need two swimming pools in each room' }
        }
      end
      it 'creates request returning created request' do
        expect(subject.dig('data', 'createRequest', 'roomClass')).to eq('Deluxe')
        expect(subject.dig('data', 'createRequest', 'comment')).to eq('I need two swimming pools in each room')
      end
    end

    context 'with valid data' do
      let(:variables) do
        {
          input: { placesAmount: nil, roomClass: 3,
                   stayTimeFrom: nil,
                   stayTimeTo: (DateTime.now + 2).iso8601,
                   comment: 'I need two swimming pools in each room' }
        }
      end
      it 'returns an error when authentications fails' do
        expect(subject['errors'].first['message']).to include('Expected value to not be null')
        expect(subject.dig('data', 'createRequest')).to be_nil
      end
    end
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
