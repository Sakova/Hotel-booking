require 'search_object'
require 'search_object/plugin/graphql'

module Resolvers
  class BillsFilter < Resolvers::BaseResolver

    type [Types::BillType], null: false

    description 'Lists bills (admin only)'

    scope { context[:current_user]&.admin? ? Bill.all : raise('You are not auth as admin to perform this action') }

    class OrderEnum < Types::BaseEnum
      graphql_name 'BillsOrder'

      value 'OLD'
      value 'RECENT'
    end

    option :user_id, type: Integer, with: :apply_user_id_filter
    option :room_id, type: Integer, with: :apply_room_id_filter
    option :order, type: OrderEnum, default: 'OLD'

    def apply_user_id_filter(scope, value)
      scope.where user_id: value
    end

    def apply_room_id_filter(scope, value)
      scope.where room_id: value
    end

    def apply_order_with_old(_)
      Bill.order created_at: :asc
    end

    def apply_order_with_recent(_)
      Bill.order created_at: :desc
    end
  end
end
