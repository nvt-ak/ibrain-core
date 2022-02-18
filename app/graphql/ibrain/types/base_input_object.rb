# frozen_string_literal: true

module Ibrain
  module Types
    class BaseInputObject < GraphQL::Schema::InputObject
      argument_class Ibrain::Types::BaseArgument

      def to_params
        ActionController::Parameters.new(
          to_h.with_indifferent_access.transform_keys(&:underscore)
        )
      end
    end
  end
end
