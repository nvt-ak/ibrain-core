# frozen_string_literal: true

module Ibrain
  module Resolvers
    class BaseResolver < GraphQL::Schema::Resolver
      argument_class ::Ibrain::Types::BaseArgument

      def current_user
        context.fetch(:current_user)
      end

      def controller
        context[:controller]
      end
    end
  end
end
