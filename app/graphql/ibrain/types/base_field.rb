# frozen_string_literal: true

module Ibrain
  module Types
    class BaseField < GraphQL::Schema::Field
      argument_class ::Ibrain::Types::BaseArgument

      def initialize(*args, default_value: nil, roles: nil, **kwargs, &block)
        super(*args, camelize: false, **kwargs, &block)

        extension(::Ibrain::Extentions::DefaultValue, default_value: default_value) unless default_value.nil?
        extension(Ibrain::Extentions::Roles, roles: roles) if roles
      end
    end
  end
end
