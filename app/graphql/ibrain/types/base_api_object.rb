# frozen_string_literal: true

module Ibrain
  module Types
    class BaseApiObject < GraphQL::Schema::Object
      include GraphQL::Relay::Node

      edge_type_class(Ibrain::Types::BaseApiEdge)
      connection_type_class(Ibrain::Types::BaseApiConnection)

      field_class Ibrain::Types::BaseApiField
    end
  end
end
