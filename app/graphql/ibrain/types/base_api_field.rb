# frozen_string_literal: true

module Ibrain
  module Types
    class BaseApiField < GraphQL::Schema::Field
      argument_class ::Ibrain::Types::BaseArgument

      def initialize(*args, session_required: true, roles: nil, **kwargs, &block)
        super(*args, camelize: false, **kwargs, &block)

        extension(Ibrain::Extentions::SessionRequired, session_required: session_required) if session_required
        extension(Ibrain::Extentions::Roles, roles: roles) if roles
      end
    end
  end
end
