require 'rails_helper'

RSpec.describe Mutations::SignOutUser, type: :graphql do
  let(:user) { users(:test) }

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
    it 'returns an error when no current user' do
      expect { subject }.to raise_error(RuntimeError)
    end
  end

  def logout_query
    <<~GQL
      mutation Logout {
        signoutUser(
          input: {}
        ) {
          success
        }
      }
    GQL
  end
end
