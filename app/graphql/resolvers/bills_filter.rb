require 'search_object'
require 'search_object/plugin/graphql'

module Resolvers
  class BillsFilter < Resolvers::BaseResolver

    type [Types::BillType], null: false

    description 'Find, Sort and Filter bills'

    scope { Bill.all }

    option :user_id, type: Integer, with: :apply_user_id_filter
    option :room_id, type: Integer, with: :apply_room_id_filter
    option :order, type: [String], with: :apply_order_filter

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
      scope = value.include?('OLD') ? Bill.order(created_at: :asc) : Bill
      scope = scope.order(created_at: :desc) if value.include?('RECENT')
      scope = scope.order(price_cents: :desc) if value.include?('HIGH_PRICE')
      scope = scope.order(price_cents: :asc) if value.include?('LOW_PRICE')

      scope
    end
  end
end
