require 'rails_helper'

RSpec.describe Mutations::SignInUser, type: :graphql do
  let(:ctx) { {} }
  subject(:query_subject) { HotelBookingSchema.execute(login_query, variables: variables, context: ctx) }

  context 'with valid credentials' do
    let(:variables) do
      { input: { credentials: { email: 'test@example.com', password: '123123' } } }
    end
    let(:ctx) { { session: { token: '' } } }

    it 'authenticates the user returning a token' do
      expect(subject.dig('data', 'signinUser', 'token')).not_to be_blank
    end
  end

  context 'with invalid credentials' do
    let(:variables) do
      { input: { credentials: { email: 'test@example.com', password: 'bad' } } }
    end

    it 'returns message when authentications fails' do
      expect(subject.dig('data', 'signinUser', 'message')).to eq('Invalid email or password')
    end
  end

  def login_query
    <<~GQL
      mutation Login($input: SignInUserInput!) {
        signinUser(
          input: $input
        ) {
          message
          token
        }
      }
    GQL
  end
end
