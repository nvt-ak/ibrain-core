# frozen_string_literal: true

module Ibrain
  module Resolvers
    class BaseAggregate < BaseResolver
      type Ibrain::Types::AggregateType.connection_type, null: false
    end
  end
end
