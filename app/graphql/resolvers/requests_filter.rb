require 'search_object'
require 'search_object/plugin/graphql'

module Resolvers
  class RequestsFilter < Resolvers::BaseSearchResolver

    type [Types::RequestType], null: false

    description 'List, Find, Sort and Filter requests (admin only)'

    scope { check_admin! ? Request.all : nil }

    class DateFilter < ::Types::BaseInputObject
      argument :time_start, String, required: true
      argument :time_end, String, required: true
    end

    class RequestOrderSort < ::Types::BaseInputObject
      argument :created_at, BaseSearchResolver::OrderEnum, required: false
      argument :places_amount, BaseSearchResolver::OrderEnum, required: false
      argument :room_class, BaseSearchResolver::OrderEnum, required: false
    end

    option :all_requests, type: BaseSearchResolver::EmptyEnum
    option :id, type: Integer, with: :apply_id_filter
    option :places_amount, type: Integer, with: :apply_places_amount_filter
    option :room_class, type: Integer, with: :apply_room_class_filter
    option :stay_time_from, type: String, with: :apply_stay_time_from_filter
    option :stay_time_to, type: String, with: :apply_stay_time_to_filter
    option :stay_between_time, type: DateFilter, with: :apply_stay_between_time_filter
    option :comment, type: String, with: :apply_comment_filter
    option :payed, type: BaseSearchResolver::EmptyEnum
    option :not_payed, type: BaseSearchResolver::EmptyEnum
    option :order, type: [RequestOrderSort], with: :apply_order_filter

    def apply_all_requests_with_empty(_)
      ::Request.all
    end

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

    def apply_payed_with_empty(_)
      Request.includes(:bill).all.filter { |r| !r.bill.nil? }
    end

    def apply_not_payed_with_empty(_)
      Request.includes(:bill).all.filter { |r| r.bill.nil? }
    end

    def apply_order_filter(_, value)
      value[0].to_h.reduce(Request) { |result, i| result.order("#{i[0]}": i[1]) }
    end
  end
end
