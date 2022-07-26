# frozen_string_literal: true

module Ibrain
  module Types
    class BaseApiObject < GraphQL::Schema::Object
      include GraphQL::Relay::Node

      edge_type_class(Ibrain::Types::BaseApiEdge)
      connection_type_class(Ibrain::Types::BaseApiConnection)

      field_class Ibrain::Types::BaseApiField

      def self.overridden_graphql_name(name = '')
        to_s.demodulize.gsub('Type', '').singularize.classify.constantize.table_name
      rescue StandardError
        return to_s.demodulize if name.blank?

        name
      end
    end
  end
end
