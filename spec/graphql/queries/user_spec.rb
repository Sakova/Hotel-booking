require 'rails_helper'

RSpec.describe Queries::User, type: :graphql do
  let(:user) { users(:test) }
  let(:admin) { users(:test_admin) }

  let(:variables) { { id: user.id } }
  subject(:query_subject) { HotelBookingSchema.execute(user_query, variables: variables, context: ctx) }

  context 'with authenticated admin' do
    let(:ctx) { { current_user: admin } }
    it 'returns info about user by id' do
      expect(subject.dig('data', 'user', 'id')).to eq(user.id.to_s)
      expect(subject.dig('data', 'user', 'name')).to eq(user.name)
      expect(subject.dig('data', 'user', 'email')).to eq(user.email)
    end
  end

  context 'with authenticated user' do
    let(:ctx) { { current_user: user } }
    it 'returns an error' do
      expect(subject.dig('data', 'user')).to be_nil
      expect(subject['errors'].first['message']).to eq('You should be authenticated as admin to perform this action')
    end
  end

  def user_query
    <<~GQL
      query($id: Int!) {
        user(id: $id) {
          id
          name
          email
        }
      }
    GQL
  end
end
