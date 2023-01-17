module Resolvers
  class BaseSearchResolver < BaseResolver
    def escape_search_term(term)
      "%#{term.gsub(/\s+/, '%')}%"
    end
  end
end
