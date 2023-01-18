require 'rails_helper'

RSpec.describe Queries::Bills, type: :graphql do
  let(:user) { users(:test) }

  it 'returns array of bills for current user' do
    result = HotelBookingSchema.execute(bills_query, context: { current_user: user })

    expect(result.dig('data', 'bills').length).to eq(bills.length)
  end

  def bills_query
    <<~GQL
      query {
        bills {
          id
        }
      }
    GQL
  end
end
