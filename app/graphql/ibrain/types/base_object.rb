# frozen_string_literal: true

module Ibrain
  module Types
    class BaseObject < GraphQL::Schema::Object
      include GraphQL::Relay::Node

      edge_type_class(Ibrain::Types::BaseEdge)
      connection_type_class(Ibrain::Types::BaseConnection)

      field_class ::Ibrain::Types::BaseField

      def self.overridden_graphql_name(name = '')
        to_s.demodulize.gsub('Type', '').singularize.classify.constantize.table_name
      rescue StandardError
        return to_s.demodulize if name.blank?

        name
      end
    end
  end
end
