# frozen_string_literal: true

module Ibrain
  module Types
    class BaseArgument < GraphQL::Schema::Argument
      def initialize(*args, **kwargs, &block)
        super(*args, camelize: false, **kwargs, &block)
      end
    end
  end
end
