# frozen_string_literal: true

module Ibrain
  module Resolvers
    class BaseResolver < GraphQL::Schema::Resolver
      def resolve(id:)
        collection.find(id)
      end

      def current_user
        context.fetch(:current_user)
      end

      private

      def collection
        Kernel.const_get(model)
      end
    end
  end
end
