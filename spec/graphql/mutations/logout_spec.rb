require 'rails_helper'

RSpec.describe Mutations::SignOutUser, type: :graphql do
  let(:user) { create(:user, :client) }

  let(:variables) { {} }
  subject(:query_subject) { HotelBookingSchema.execute(logout_query, variables: variables, context: ctx) }

  context 'with authenticated user' do
    let(:ctx) { { current_user: user, session: { token: '' } } }
    it 'log out the user' do
      expect(subject.dig('data', 'signoutUser', 'success')).to be_truthy
    end
  end

  context 'without authenticated user' do
    let(:ctx) { { current_user: nil, session: { token: '' } } }
    it 'returns message when no current user' do
      expect(subject.dig('data', 'signoutUser', 'message')).to eq('There is no authenticated user')
    end
  end

  def logout_query
    <<~GQL
      mutation Logout {
        signoutUser(
          input: {}
        ) {
          message
          success
        }
      }
    GQL
  end
end
