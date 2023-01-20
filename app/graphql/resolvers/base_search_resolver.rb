module Resolvers
  class BaseSearchResolver < BaseResolver
    class OrderEnum < Types::BaseEnum
      value 'ASC'
      value 'DESC'
    end

    class EmptyEnum < Types::BaseEnum
      value 'EMPTY'
    end

    def escape_search_term(term)
      "%#{term.gsub(/\s+/, '%')}%"
    end
  end
end
