# frozen_string_literal: true

module Ibrain
  module Types
    class BaseApiConnection < Types::BaseObject
      # add `nodes` and `pageInfo` fields, as well as `edge_type(...)` and `node_nullable(...)` overrides
      include GraphQL::Types::Relay::ConnectionBehaviors

      field :count, Integer, null: false, camelize: false

      def count
        object.items.size
      end
    end
  end
end
