require 'rails_helper'

RSpec.describe Resolvers::RequestsFilter, type: :graphql do
  let(:user) { users(:test) }
  let(:admin) { users(:test_admin) }
  let(:request) { requests(:first_request) }
  let(:request_not_payed) { requests(:not_payed_request) }

  describe 'id filter' do
    query = <<~GQL
      query($id: Int) {
        requestsFilter(id: $id) {
          id
          placesAmount
        }
      }
    GQL

    context 'with authenticated admin' do
      it 'takes request id and returning request by id' do

        result = HotelBookingSchema.execute(query, variables: { id: request.id },
                                                   context: { current_user: admin })

        expect(result.dig('data', 'requestsFilter')[0]['id']).to eq(request.id.to_s)
        expect(result.dig('data', 'requestsFilter')[0]['placesAmount']).to eq(request.places_amount)
      end
    end

    context 'with authenticated user' do
      it 'returns an error' do
        expect do
          HotelBookingSchema.execute(query, variables: { id: request.id },
                                            context: { current_user: user })
        end.to raise_error(RuntimeError)
      end
    end
  end

  describe 'placesAmount filter' do
    query = <<~GQL
      query($places: Int) {
        requestsFilter(placesAmount: $places) {
          id
          placesAmount
        }
      }
    GQL

    context 'with authenticated admin' do
      it 'takes request places amount and returning requests by places amount' do

        result = HotelBookingSchema.execute(query, variables: { places: request.places_amount },
                                                   context: { current_user: admin })

        expect(result.dig('data', 'requestsFilter')[0]['id']).to eq(request.id.to_s)
        expect(result.dig('data', 'requestsFilter')[0]['placesAmount']).to eq(request.places_amount)
      end
    end

    context 'with authenticated user' do
      it 'returns an error' do
        expect do
          HotelBookingSchema.execute(query, variables: { places: request.places_amount },
                                            context: { current_user: user })
        end.to raise_error(RuntimeError)
      end
    end
  end

  describe 'stayTimeFrom filter' do
    query = <<~GQL
      query($timeFrom: String!) {
        requestsFilter(stayTimeFrom: $timeFrom) {
          id
          placesAmount
        }
      }
    GQL

    context 'with authenticated admin' do
      it 'takes request stay time from and returning requests by stay time from' do

        result = HotelBookingSchema.execute(query, variables: { timeFrom: request.stay_time_from.to_s },
                                                   context: { current_user: admin })

        expect(result.dig('data', 'requestsFilter')[0]['id']).to eq(request.id.to_s)
        expect(result.dig('data', 'requestsFilter')[0]['placesAmount']).to eq(request.places_amount)
      end
    end

    context 'with authenticated user' do
      it 'returns an error' do
        expect do
          HotelBookingSchema.execute(query, variables: { timeFrom: request.stay_time_from.to_s },
                                            context: { current_user: user })
        end.to raise_error(RuntimeError)
      end
    end
  end

  describe 'stayTimeTo filter' do
    query = <<~GQL
      query($timeTo: String!) {
        requestsFilter(stayTimeTo: $timeTo) {
          id
          placesAmount
        }
      }
    GQL

    context 'with authenticated admin' do
      it 'takes request stay time to and returning requests by stay time to' do

        result = HotelBookingSchema.execute(query, variables: { timeTo: request.stay_time_to.to_s },
                                                   context: { current_user: admin })

        expect(result.dig('data', 'requestsFilter')[0]['id']).to eq(request.id.to_s)
        expect(result.dig('data', 'requestsFilter')[0]['placesAmount']).to eq(request.places_amount)
      end
    end

    context 'with authenticated user' do
      it 'returns an error' do
        expect do
          HotelBookingSchema.execute(query, variables: { timeTo: request.stay_time_to.to_s },
                                            context: { current_user: user })
        end.to raise_error(RuntimeError)
      end
    end
  end

  describe 'stayBetweenTime filter' do
    query = <<~GQL
      query($timeStart: String!, $timeEnd: String!) {
        requestsFilter(stayBetweenTime: {timeStart : $timeStart, timeEnd: $timeEnd}) {
          id
          placesAmount
        }
      }
    GQL

    context 'with authenticated admin' do
      it 'takes stayBetweenTime to and returning request by time between' do

        result = HotelBookingSchema.execute(query, variables: { timeStart: request.stay_time_from.to_s,
                                                                timeEnd: (request.stay_time_to + 1).to_s },
                                                   context: { current_user: admin })

        expect(result.dig('data', 'requestsFilter')[0]['id']).to eq(request.id.to_s)
        expect(result.dig('data', 'requestsFilter')[0]['placesAmount']).to eq(request.places_amount)
      end
    end

    context 'with authenticated user' do
      it 'returns an error' do
        expect do
          HotelBookingSchema.execute(query, variables: { timeStart: request.stay_time_from.to_s,
                                                         timeEnd: (request.stay_time_to + 1).to_s },
                                            context: { current_user: user })
        end.to raise_error(RuntimeError)
      end
    end
  end

  describe 'comment filter' do
    query = <<~GQL
      query($comment: String!) {
        requestsFilter(comment: $comment) {
          id
          placesAmount
        }
      }
    GQL

    context 'with authenticated admin' do
      it 'takes string and returning requests by found comment' do

        result = HotelBookingSchema.execute(query, variables: { comment: request.comment },
                                                   context: { current_user: admin })

        expect(result.dig('data', 'requestsFilter')[0]['id']).to eq(request.id.to_s)
        expect(result.dig('data', 'requestsFilter')[0]['placesAmount']).to eq(request.places_amount)
      end
    end

    context 'with authenticated user' do
      it 'returns an error' do
        expect do
          HotelBookingSchema.execute(query, variables: { comment: request.comment },
                                            context: { current_user: user })
        end.to raise_error(RuntimeError)
      end
    end
  end

  describe 'payed filter' do
    query = <<~GQL
      query {
        requestsFilter(payed: "") {
          id
          placesAmount
        }
      }
    GQL

    context 'with authenticated admin' do
      it 'takes empty string and returning requests with payed bills' do

        result = HotelBookingSchema.execute(query, context: { current_user: admin })

        expect(result.dig('data', 'requestsFilter')[0]['id']).to eq(request.id.to_s)
        expect(result.dig('data', 'requestsFilter')[0]['placesAmount']).to eq(request.places_amount)
      end
    end

    context 'with authenticated user' do
      it 'returns an error' do
        expect do
          HotelBookingSchema.execute(query, context: { current_user: user })
        end.to raise_error(RuntimeError)
      end
    end
  end

  describe 'notPayed filter' do
    query = <<~GQL
      query {
        requestsFilter(notPayed: "") {
          id
          placesAmount
        }
      }
    GQL

    context 'with authenticated admin' do
      it 'takes empty string and returning requests with not payed bills' do

        result = HotelBookingSchema.execute(query, context: { current_user: admin })

        expect(result.dig('data', 'requestsFilter')[0]['id']).to eq(request_not_payed.id.to_s)
        expect(result.dig('data', 'requestsFilter')[0]['placesAmount']).to eq(request_not_payed.places_amount)
      end
    end

    context 'with authenticated user' do
      it 'returns an error' do
        expect do
          HotelBookingSchema.execute(query, context: { current_user: user })
        end.to raise_error(RuntimeError)
      end
    end
  end

  describe 'order sorting' do
    context 'with authenticated admin' do
      it 'takes OLD order and returning requests sorting by OLD records' do
        query = <<~GQL
          query {
            requestsFilter(order: OLD) {
              id
              placesAmount
            }
          }
        GQL

        result = HotelBookingSchema.execute(query, context: { current_user: admin })

        expect(result.dig('data', 'requestsFilter')[0]['id']).to eq(request.id.to_s)
        expect(result.dig('data', 'requestsFilter')[0]['placesAmount']).to eq(request.places_amount)
      end

      it 'takes RECENT order and returning requests sorting by RECENT records' do
        query = <<~GQL
          query {
            requestsFilter(order: RECENT) {
              id
              placesAmount
            }
          }
        GQL

        result = HotelBookingSchema.execute(query, context: { current_user: admin })

        expect(result.dig('data', 'requestsFilter')[0]['id']).to eq(request.id.to_s)
        expect(result.dig('data', 'requestsFilter')[0]['placesAmount']).to eq(request.places_amount)
      end

      it 'takes MORE_PLACES order and returning requests sorting by MORE PLACES records' do
        query = <<~GQL
          query {
            requestsFilter(order: MORE_PLACES) {
              id
              placesAmount
            }
          }
        GQL

        result = HotelBookingSchema.execute(query, context: { current_user: admin })

        expect(result.dig('data', 'requestsFilter')[0]['id']).to eq(request_not_payed.id.to_s)
        expect(result.dig('data', 'requestsFilter')[0]['placesAmount']).to eq(request_not_payed.places_amount)
      end

      it 'takes LESS_PLACES order and returning requests sorting by LESS PLACES records' do
        query = <<~GQL
          query {
            requestsFilter(order: LESS_PLACES) {
              id
              placesAmount
            }
          }
        GQL

        result = HotelBookingSchema.execute(query, context: { current_user: admin })

        expect(result.dig('data', 'requestsFilter')[0]['id']).to eq(request.id.to_s)
        expect(result.dig('data', 'requestsFilter')[0]['placesAmount']).to eq(request.places_amount)
      end

      it 'takes TOP_CLASS_ROOMS order and returning requests sorting by TOP CLASS ROOMS records' do
        query = <<~GQL
          query {
            requestsFilter(order: TOP_CLASS_ROOMS) {
              id
              placesAmount
            }
          }
        GQL

        result = HotelBookingSchema.execute(query, context: { current_user: admin })

        expect(result.dig('data', 'requestsFilter')[0]['id']).to eq(request_not_payed.id.to_s)
        expect(result.dig('data', 'requestsFilter')[0]['placesAmount']).to eq(request_not_payed.places_amount)
      end

      it 'takes LOWER_CLASS_ROOMS order and returning requests sorting by LOWER CLASS ROOMS records' do
        query = <<~GQL
          query {
            requestsFilter(order: LOWER_CLASS_ROOMS) {
              id
              placesAmount
            }
          }
        GQL

        result = HotelBookingSchema.execute(query, context: { current_user: admin })

        expect(result.dig('data', 'requestsFilter')[0]['id']).to eq(request.id.to_s)
        expect(result.dig('data', 'requestsFilter')[0]['placesAmount']).to eq(request.places_amount)
      end
    end

    context 'with authenticated user' do
      it 'returns an error' do
        query = <<~GQL
          query {
            requestsFilter(notPayed: "") {
              id
              placesAmount
            }
          }
        GQL

        expect do
          HotelBookingSchema.execute(query, context: { current_user: user })
        end.to raise_error(RuntimeError)
      end
    end
  end
end
