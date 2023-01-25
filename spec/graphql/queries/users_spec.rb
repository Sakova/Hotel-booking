require 'rails_helper'

RSpec.describe Queries::Users, type: :graphql do
  let(:user) { create(:user, :client) }
  let(:admin) { create(:user, :admin) }

  let(:variables) { {} }
  subject(:query_subject) { HotelBookingSchema.execute(users_query, variables: variables, context: ctx) }

  context 'with authenticated admin' do
    let(:ctx) { { current_user: admin } }
    it 'returns array of registered users' do
      expect(subject.dig('data', 'users')[0]).to include('id', 'name', 'email')
    end
  end

  context 'with authenticated user' do
    let(:ctx) { { current_user: user } }
    it 'returns an error' do
      expect(subject.dig('data', 'users')).to be_nil
      expect(subject['errors'].first['message']).to eq('You should be authenticated as admin to perform this action')
    end
  end

  def users_query
    <<~GQL
      query {
        users {
          id
          name
          email
        }
      }
    GQL
  end
end
