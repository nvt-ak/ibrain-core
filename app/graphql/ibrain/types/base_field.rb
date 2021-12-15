module Ibrain
  module Types
    class BaseField < GraphQL::Schema::Field
      argument_class ::Ibrain::Types::BaseArgument

      def initialize(*args, default_value: nil, **kwargs, &block)
        super(*args, **kwargs, &block)

        extension(::Ibrain::Extentions::DefaultValue, default_value: default_value) unless default_value.nil?
      end
    end
  end
end