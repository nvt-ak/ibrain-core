# frozen_string_literal: true

module Ibrain
  module Types
    class BaseEdge < Types::BaseObject
      include GraphQL::Types::Relay::EdgeBehaviors
      include GraphQL::Relay::Node

      edge_type_class(Ibrain::Types::BaseEdge)
      connection_type_class(Ibrain::Types::BaseConnection)

      field_class ::Ibrain::Types::BaseField
    end
  end
end
