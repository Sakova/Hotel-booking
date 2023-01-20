require 'rails_helper'

RSpec.describe Resolvers::RequestsFilter, type: :graphql do
  let(:user) { users(:test) }
  let(:admin) { users(:test_admin) }
  let(:request) { requests(:first_request) }
  let(:request_not_payed) { requests(:not_payed_request) }

  let(:variables) { {} }
  subject(:query_subject) { HotelBookingSchema.execute(query, variables: variables, context: ctx) }

  describe 'all requests' do
    let(:query) { <<~GQL }
      query {
        requests(allRequests: EMPTY) {
          id
          placesAmount
        }
      }
    GQL

    context 'with authenticated admin' do
      let(:ctx) { { current_user: admin } }
      it 'takes EMPTY and returning all requests' do
        expect(subject.dig('data', 'requests')[0]['id']).to eq(request.id.to_s)
        expect(subject.dig('data', 'requests')[0]['placesAmount']).to eq(request.places_amount)
      end
    end

    context 'with authenticated user' do
      let(:ctx) { { current_user: user } }
      it 'returns an error' do
        expect(subject['errors'].first['message']).to eq('You need to authenticate as admin to perform this action')
      end
    end
  end

  describe 'id filter' do
    let(:query) { <<~GQL }
      query($id: Int) {
        requests(id: $id) {
          id
          placesAmount
        }
      }
    GQL
    let(:variables) { { id: request.id } }

    context 'with authenticated admin' do
      let(:ctx) { { current_user: admin } }
      it 'takes request id and returning request by id' do
        expect(subject.dig('data', 'requests')[0]['id']).to eq(request.id.to_s)
        expect(subject.dig('data', 'requests')[0]['placesAmount']).to eq(request.places_amount)
      end
    end

    context 'with authenticated user' do
      let(:ctx) { { current_user: user } }
      it 'returns an error' do
        expect(subject['errors'].first['message']).to eq('You need to authenticate as admin to perform this action')
      end
    end
  end

  describe 'placesAmount filter' do
    let(:query) { <<~GQL }
      query($places: Int) {
        requests(placesAmount: $places) {
          id
          placesAmount
        }
      }
    GQL
    let(:variables) { { places: request.places_amount } }

    context 'with authenticated admin' do
      let(:ctx) { { current_user: admin } }
      it 'takes places amount and returning requests by places amount' do
        expect(subject.dig('data', 'requests')[0]['id']).to eq(request.id.to_s)
        expect(subject.dig('data', 'requests')[0]['placesAmount']).to eq(request.places_amount)
      end
    end

    context 'with authenticated user' do
      let(:ctx) { { current_user: user } }
      it 'returns an error' do
        expect(subject['errors'].first['message']).to eq('You need to authenticate as admin to perform this action')
      end
    end
  end

  describe 'stayTimeFrom filter' do
    let(:query) { <<~GQL }
      query($timeFrom: String!) {
        requests(stayTimeFrom: $timeFrom) {
          id
          placesAmount
        }
      }
    GQL
    let(:variables) { { timeFrom: request.stay_time_from.to_s } }

    context 'with authenticated admin' do
      let(:ctx) { { current_user: admin } }
      it 'takes request stay time from and returning requests by stay time from' do
        expect(subject.dig('data', 'requests')[0]['id']).to eq(request.id.to_s)
        expect(subject.dig('data', 'requests')[0]['placesAmount']).to eq(request.places_amount)
      end
    end

    context 'with authenticated user' do
      let(:ctx) { { current_user: user } }
      it 'returns an error' do
        expect(subject['errors'].first['message']).to eq('You need to authenticate as admin to perform this action')
      end
    end
  end

  describe 'stayTimeTo filter' do
    let(:query) { <<~GQL }
      query($timeTo: String!) {
        requests(stayTimeTo: $timeTo) {
          id
          placesAmount
        }
      }
    GQL
    let(:variables) { { timeTo: request.stay_time_to.to_s } }

    context 'with authenticated admin' do
      let(:ctx) { { current_user: admin } }
      it 'takes request stay time to and returning requests by stay time to' do
        expect(subject.dig('data', 'requests')[0]['id']).to eq(request.id.to_s)
        expect(subject.dig('data', 'requests')[0]['placesAmount']).to eq(request.places_amount)
      end
    end

    context 'with authenticated user' do
      let(:ctx) { { current_user: user } }
      it 'returns an error' do
        expect(subject['errors'].first['message']).to eq('You need to authenticate as admin to perform this action')
      end
    end
  end

  describe 'stayBetweenTime filter' do
    let(:query) { <<~GQL }
      query($timeStart: String!, $timeEnd: String!) {
        requests(stayBetweenTime: {timeStart : $timeStart, timeEnd: $timeEnd}) {
          id
          placesAmount
        }
      }
    GQL
    let(:variables) do
      { timeStart: request.stay_time_from.to_s,
        timeEnd: (request.stay_time_to + 1).to_s }
    end

    context 'with authenticated admin' do
      let(:ctx) { { current_user: admin } }
      it 'takes stayBetweenTime to and returning request by time between' do
        expect(subject.dig('data', 'requests')[0]['id']).to eq(request.id.to_s)
        expect(subject.dig('data', 'requests')[0]['placesAmount']).to eq(request.places_amount)
      end
    end

    context 'with authenticated user' do
      let(:ctx) { { current_user: user } }
      it 'returns an error' do
        expect(subject['errors'].first['message']).to eq('You need to authenticate as admin to perform this action')
      end
    end
  end

  describe 'comment filter' do
    let(:query) { <<~GQL }
      query($comment: String!) {
        requests(comment: $comment) {
          id
          placesAmount
        }
      }
    GQL
    let(:variables) { { comment: request.comment } }

    context 'with authenticated admin' do
      let(:ctx) { { current_user: admin } }
      it 'takes string and returning requests by found comment' do
        expect(subject.dig('data', 'requests')[0]['id']).to eq(request.id.to_s)
        expect(subject.dig('data', 'requests')[0]['placesAmount']).to eq(request.places_amount)
      end
    end

    context 'with authenticated user' do
      let(:ctx) { { current_user: user } }
      it 'returns an error' do
        expect(subject['errors'].first['message']).to eq('You need to authenticate as admin to perform this action')
      end
    end
  end

  describe 'payed filter' do
    let(:query) { <<~GQL }
      query {
        requests(payed: EMPTY) {
          id
          placesAmount
        }
      }
    GQL

    context 'with authenticated admin' do
      let(:ctx) { { current_user: admin } }
      it 'takes empty string and returning requests with payed bills' do
        expect(subject.dig('data', 'requests')[0]['id']).to eq(request.id.to_s)
        expect(subject.dig('data', 'requests')[0]['placesAmount']).to eq(request.places_amount)
      end
    end

    context 'with authenticated user' do
      let(:ctx) { { current_user: user } }
      it 'returns an error' do
        expect(subject['errors'].first['message']).to eq('You need to authenticate as admin to perform this action')
      end
    end
  end

  describe 'notPayed filter' do
    let(:query) { <<~GQL }
      query {
        requests(notPayed: EMPTY) {
          id
          placesAmount
        }
      }
    GQL

    context 'with authenticated admin' do
      let(:ctx) { { current_user: admin } }
      it 'takes empty string and returning requests with not payed bills' do
        expect(subject.dig('data', 'requests')[0]['id']).to eq(request_not_payed.id.to_s)
        expect(subject.dig('data', 'requests')[0]['placesAmount']).to eq(request_not_payed.places_amount)
      end
    end

    context 'with authenticated user' do
      let(:ctx) { { current_user: user } }
      it 'returns an error' do
        expect(subject['errors'].first['message']).to eq('You need to authenticate as admin to perform this action')
      end
    end
  end

  describe 'order sorting' do
    context 'with authenticated admin' do
      let(:ctx) { { current_user: admin } }
      context 'with DESC order' do
        let(:query) { <<~GQL }
          query {
            requests(order: [{createdAt: DESC}]) {
              id
              placesAmount
            }
          }
        GQL

        it 'returns requests sorting by created_at field' do
          expect(subject.dig('data', 'requests')[0]['id']).to eq(request.id.to_s)
          expect(subject.dig('data', 'requests')[0]['placesAmount']).to eq(request.places_amount)
        end
      end

      context 'with ASC order' do
        let(:query) { <<~GQL }
          query {
            requests(order: [{createdAt: ASC}]) {
              id
              placesAmount
            }
          }
        GQL

        it 'returns requests sorting by created_at field' do
          expect(subject.dig('data', 'requests')[0]['id']).to eq(request.id.to_s)
          expect(subject.dig('data', 'requests')[0]['placesAmount']).to eq(request.places_amount)
        end
      end

      context 'with DESC order' do
        let(:query) { <<~GQL }
          query {
            requests(order: [{placesAmount: DESC}]) {
              id
              placesAmount
            }
          }
        GQL

        it 'returns requests sorting by places_amount field' do
          expect(subject.dig('data', 'requests')[0]['id']).to eq(request_not_payed.id.to_s)
          expect(subject.dig('data', 'requests')[0]['placesAmount']).to eq(request_not_payed.places_amount)
        end
      end

      context 'with ASC order' do
        let(:query) { <<~GQL }
          query {
            requests(order: [{placesAmount: ASC}]) {
              id
              placesAmount
            }
          }
        GQL

        it 'returns requests sorting by places_amount field' do
          expect(subject.dig('data', 'requests')[0]['id']).to eq(request.id.to_s)
          expect(subject.dig('data', 'requests')[0]['placesAmount']).to eq(request.places_amount)
        end
      end

      context 'with DESC order' do
        let(:query) { <<~GQL }
          query {
            requests(order: [{roomClass: DESC}]) {
              id
              placesAmount
            }
          }
        GQL

        it 'returns requests sorting by room_class field' do
          expect(subject.dig('data', 'requests')[0]['id']).to eq(request_not_payed.id.to_s)
          expect(subject.dig('data', 'requests')[0]['placesAmount']).to eq(request_not_payed.places_amount)
        end
      end

      context 'with ASC order' do
        let(:query) { <<~GQL }
          query {
            requests(order: [{roomClass: ASC}]) {
              id
              placesAmount
            }
          }
        GQL

        it 'returns requests sorting by LOWER CLASS ROOMS records' do
          expect(subject.dig('data', 'requests')[0]['id']).to eq(request.id.to_s)
          expect(subject.dig('data', 'requests')[0]['placesAmount']).to eq(request.places_amount)
        end
      end
    end

    context 'with authenticated user' do
      let(:query) { <<~GQL }
        query {
          requests(order: [{roomClass: ASC}]) {
            id
            placesAmount
          }
        }
      GQL
      let(:ctx) { { current_user: user } }

      it 'returns an error' do
        expect(subject['errors'].first['message']).to eq('You need to authenticate as admin to perform this action')
      end
    end
  end
end
