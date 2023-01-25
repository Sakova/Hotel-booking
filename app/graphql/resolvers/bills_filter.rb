require 'search_object'
require 'search_object/plugin/graphql'

module Resolvers
  class BillsFilter < Resolvers::BaseSearchResolver

    type [Types::BillType], null: false

    description 'Find, Sort and Filter bills (only for admin except searching by id)'

    scope { Bill.all }

    class OrderSort < ::Types::BaseInputObject
      argument :created_at, BaseSearchResolver::OrderEnum, required: false
      argument :price_cents, BaseSearchResolver::OrderEnum, required: false
    end

    option :user_id, type: Integer, with: :apply_user_id_filter
    option :room_id, type: Integer, with: :apply_room_id_filter
    option :order, type: [OrderSort], with: :apply_order_filter

    def apply_user_id_filter(scope, value)
      check_authentication!
      scope.where user_id: value
    end

    def apply_room_id_filter(scope, value)
      check_admin!
      scope.where room_id: value
    end

    def apply_order_filter(_, value)
      check_admin!

      value[0].to_h.reduce(Bill) { |result, i| result.order("#{i[0]}": i[1]) }
    end
  end
end
