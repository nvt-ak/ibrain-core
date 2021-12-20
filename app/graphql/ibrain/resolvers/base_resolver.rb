# frozen_string_literal: true

module Ibrain
  module Resolvers
    class BaseResolver < GraphQL::Schema::Resolver
      argument :filter, Ibrain::Types::FilterType, required: false, default_value: nil
      argument :limit, Int, required: false, default_value: 10
      argument :offset, Int, required: false, default_value: 0

      def current_user
        context.fetch(:current_user)
      end
    end
  end
end
