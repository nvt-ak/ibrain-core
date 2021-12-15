module Ibrain
  module Util
    class QueryCombiner
      def self.combine(query_types)
        Array(query_types).inject({}) do |acc, query_type|
          acc.merge!(query_type.fields)
        end
      end
    end
  end
end