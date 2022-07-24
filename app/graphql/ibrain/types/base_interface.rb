# frozen_string_literal: true

module Ibrain
  module Types
    module BaseInterface
      include GraphQL::Schema::Interface

      edge_type_class(Ibrain::Types::BaseApiEdge)
      connection_type_class(Ibrain::Types::BaseConnection)

      field_class Ibrain::Types::BaseField
    end
  end
end
