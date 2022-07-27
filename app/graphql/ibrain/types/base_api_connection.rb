# frozen_string_literal: true

module Ibrain
  module Types
    class BaseApiConnection < Types::BaseObject
      # add `nodes` and `pageInfo` fields, as well as `edge_type(...)` and `node_nullable(...)` overrides
      include GraphQL::Types::Relay::ConnectionBehaviors

      field :aggregate, Ibrain::Types::AggregateType, null: false, camelize: false

      def aggregate
        Ibrain::Aggregate.new(object.items.size)
      end
    end
  end
end
