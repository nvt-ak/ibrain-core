# frozen_string_literal: true

module Ibrain
  module Resolvers
    class BaseAggregate < BaseResolver
      type Ibrain::Types::BaseObject.connection_type, null: false

      argument :where, Ibrain::Types::FilterType, required: false, default_value: nil
      argument :limit, Int, required: false, default_value: 10
      argument :offset, Int, required: false, default_value: 0
    end
  end
end
