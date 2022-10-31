# frozen_string_literal: true

module Ibrain
  module Types
    class BaseApiField < GraphQL::Schema::Field
      argument_class ::Ibrain::Types::BaseArgument

      def initialize(*args, session_required: true, roles: nil, active_required: true, **kwargs, &block)
        super(*args, camelize: false, **kwargs, &block)

        extension(Ibrain::Extentions::SessionRequired, session_required: session_required) if session_required
        extension(Ibrain::Extentions::Roles, roles: roles) if roles

        if Ibrain::Config.is_require_activated_account && active_required
          extension(Ibrain::Extentions::ActiveRequired)
        end
      end
    end
  end
end
