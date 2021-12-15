# frozen_string_literal: true

module Ibrain
  module Resolvers
    class BaseResolver < GraphQL::Schema::Resolver
      def resolve(id:)
        collection.find try_decode(id)
      end

      def current_user
        context.fetch(:current_user)
      end

      def try_decode(id)
        _, decode_id = GraphQL::Schema::UniqueWithinType.decode(id)

        decode_id
      rescue StandardError
        id
      end

      private

      def collection
        Kernel.const_get(model)
      end

      def model
        self.class.type.of_type.name.demodulize.split('Type').first
      end
    end
  end
end
