# frozen_string_literal: true

module Ibrain
  module Types
    class BaseUnion < GraphQL::Schema::Union
      edge_type_class(Ibrain::Types::BaseEdge)
      connection_type_class(Ibrain::Types::BaseConnection)
    end
  end
end
