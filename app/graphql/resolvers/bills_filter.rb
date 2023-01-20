require 'search_object'
require 'search_object/plugin/graphql'

module Resolvers
  class BillsFilter < Resolvers::BaseResolver

    type [Types::BillType], null: false

    description 'Find, Sort and Filter bills'

    scope { Bill.all }

    class OrderEnum < Types::BaseEnum
      value 'ASC'
      value 'DESC'
    end

    class OrderSort < ::Types::BaseInputObject
      argument :created_at, OrderEnum, required: false
      argument :price_cents, OrderEnum, required: false
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

      value = value[0]
      scope = value[:created_at].present? ? Bill.order(created_at: value[:created_at]) : Bill
      scope = scope.order(price_cents: value[:price_cents]) if value[:price_cents].present?

      scope
    end
  end
end
