require 'rails_helper'

RSpec.describe Mutations::CreateUser, type: :graphql do
  let(:ctx) { {} }
  subject(:query_subject) { HotelBookingSchema.execute(register_query, variables: variables, context: ctx) }

  context 'with valid data' do
    let(:variables) do
      {
        input: { name: 'test',
                 authProvider:
                   { credentials:
                       { email: 'test_c@example.com', password: '123123' } } }
      }
    end
    it 'creates a new account returning the user' do
      expect(subject.dig('data', 'createUser', 'email')).to eq('test_c@example.com')
    end
  end

  context 'with invalid data' do
    let(:variables) do
      {
        input: { name: 'test',
                 authProvider:
                   { credentials:
                       { email: 'test_c@example.com', password: 'bad' } } }
      }
    end
    it 'returns an error when validation fails' do
      expect(subject.dig('data', 'createUser')).to be_nil
      expect(subject['errors'].first['message']).to eq('Invalid input: Password is too short (minimum is 6 characters)')
    end
  end

  def register_query
    <<~GQL
      mutation Register($input: CreateUserInput!) {
        createUser(
          input: $input
        ) {
          email
        }
      }
    GQL
  end
end
