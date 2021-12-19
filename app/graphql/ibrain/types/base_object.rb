# frozen_string_literal: true

module Ibrain
  module Types
    class BaseObject < GraphQL::Schema::Object
      implements GraphQL::Relay::Node.interface

      edge_type_class(Ibrain::Types::BaseEdge)
      connection_type_class(Ibrain::Types::BaseConnection)

      field_class ::Ibrain::Types::BaseField
    end
  end
end
