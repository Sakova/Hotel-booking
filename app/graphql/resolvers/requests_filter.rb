require 'search_object'
require 'search_object/plugin/graphql'

module Resolvers
  class RequestsFilter < Resolvers::BaseSearchResolver

    type [Types::RequestType], null: false

    description 'Sort and Filter requests (admin only)'

    scope { check_admin! ? Request.all : nil }

    class DateFilter < ::Types::BaseInputObject
      argument :time_start, String, required: true
      argument :time_end, String, required: true
    end

    class OrderEnum < Types::BaseEnum
      graphql_name 'RequestOrder'

      value 'OLD'
      value 'RECENT'
      value 'MORE_PLACES'
      value 'LESS_PLACES'
      value 'TOP_CLASS_ROOMS'
      value 'LOWER_CLASS_ROOMS'
    end

    option :id, type: Integer, with: :apply_id_filter
    option :places_amount, type: Integer, with: :apply_places_amount_filter
    option :room_class, type: Integer, with: :apply_room_class_filter
    option :stay_time_from, type: String, with: :apply_stay_time_from_filter
    option :stay_time_to, type: String, with: :apply_stay_time_to_filter
    option :stay_between_time, type: DateFilter, with: :apply_stay_between_time_filter
    option :comment, type: String, with: :apply_comment_filter
    option :payed, type: String, with: :apply_payed_filter
    option :not_payed, type: String, with: :apply_not_payed_filter
    option :order, type: OrderEnum, default: 'OLD'

    def apply_id_filter(scope, value)
      scope.where id: value
    end

    def apply_places_amount_filter(scope, value)
      scope.where places_amount: value
    end

    def apply_room_class_filter(scope, value)
      scope.where room_class: value
    end

    def apply_stay_time_from_filter(scope, value)
      scope.where(stay_time_from: Date.parse(value).all_day)
    end

    def apply_stay_time_to_filter(scope, value)
      scope.where(stay_time_to: Date.parse(value).all_day)
    end

    def apply_stay_between_time_filter(scope, value)
      scope.where('stay_time_from BETWEEN ? AND ?', value[:time_start], value[:time_end])
    end

    def apply_comment_filter(scope, value)
      scope.where 'LOWER(comment) LIKE ?', escape_search_term(value.downcase)
    end

    def apply_payed_filter(_, _)
      Request.includes(:bill).all.filter { |r| !r.bill.nil? }
    end

    def apply_not_payed_filter(_, _)
      Request.includes(:bill).all.filter { |r| r.bill.nil? }
    end

    def apply_order_with_old(_)
      Request.order created_at: :asc
    end

    def apply_order_with_recent(_)
      Request.order created_at: :desc
    end

    def apply_order_with_more_places(_)
      Request.order places_amount: :desc
    end

    def apply_order_with_less_places(_)
      Request.order places_amount: :asc
    end

    def apply_order_with_top_class_rooms(_)
      Request.order room_class: :desc
    end

    def apply_order_with_lower_class_rooms(_)
      Request.order room_class: :asc
    end
  end
end
