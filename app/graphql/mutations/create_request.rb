module Mutations
  class CreateRequest < BaseMutation
    description 'Create request'

    null true
    argument :places_amount, Integer, required: true
    argument :room_class, Integer, required: true
    argument :stay_time_from, GraphQL::Types::ISO8601DateTime, required: true
    argument :stay_time_to, GraphQL::Types::ISO8601DateTime, required: true
    argument :comment, String, required: false

    field :request, Types::RequestType, null: true
    field :message, String, null: true

    def resolve(places_amount: nil, room_class: nil, stay_time_from: nil, stay_time_to: nil, comment: nil)
      return { message: 'You are not authenticated to perform this action' } unless context[:current_user]

      request = Request.create!(
        places_amount: places_amount,
        room_class: room_class,
        stay_time_from: stay_time_from,
        stay_time_to: stay_time_to,
        comment: comment,
        user: context[:current_user]
      )

      { request: request }

    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
