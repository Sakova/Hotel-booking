require 'rails_helper'

RSpec.describe Mutations::CreateUser, type: :graphql do
  it 'creates a new account returning the user' do
    result = HotelBookingSchema.execute(register_query, variables: {
                                          input: { name: 'test',
                                                   authProvider:
                                                     { credentials:
                                                         { email: 'test_c@example.com', password: '123123' } } }
                                        })

    expect(result.dig('data', 'createUser', 'email')).to eq('test_c@example.com')
  end

  it 'returns an error when validation fails' do
    result = HotelBookingSchema.execute(register_query, variables: {
                                          input: { name: 'test',
                                                   authProvider:
                                                     { credentials:
                                                         { email: 'test_c@example.com', password: 'bad' } } }
                                        })

    expect(result.dig('data', 'createUser')).to be_nil
    expect(result['errors'].first['message']).to eq('Invalid input: Password is too short (minimum is 6 characters)')
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
