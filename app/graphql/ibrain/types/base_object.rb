# frozen_string_literal: true

module Ibrain
  module Types
    class BaseObject < GraphQL::Schema::Object
      include GraphQL::Relay::Node

      edge_type_class(Ibrain::Types::BaseEdge)
      connection_type_class(Ibrain::Types::BaseConnection)

      field_class ::Ibrain::Types::BaseField

      field :name, String, null: true

      protected

      def loader
        Ibrain::Loaders::AssociationLoader
      end

      def current_user
        context.try(:fetch, :current_user)
      end
    end
  end
end
