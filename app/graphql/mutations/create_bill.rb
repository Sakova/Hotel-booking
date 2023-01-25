module Mutations
  class CreateBill < BaseMutation
    description 'Create bill (admin only)'

    null true
    argument :price, Integer, required: true
    argument :user_id, Integer, required: true
    argument :request_id, Integer, required: true
    argument :room_id, Integer, required: true

    field :bill, Types::BillType, null: true
    field :message, String, null: true

    def resolve(price: nil, user_id: nil, request_id: nil, room_id: nil)
      return { message: 'You do not have permission to perform this action' } unless context[:current_user]&.admin?

      bill = Bill.create!(
        price: price,
        user_id: user_id,
        request_id: request_id,
        room_id: room_id
      )

      { bill: bill }

    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
