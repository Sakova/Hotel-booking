module Resolvers
  class BaseSearchResolver < BaseResolver
    class OrderEnum < Types::BaseEnum
      value 'ASC'
      value 'DESC'
    end

    def escape_search_term(term)
      "%#{term.gsub(/\s+/, '%')}%"
    end
  end
end
