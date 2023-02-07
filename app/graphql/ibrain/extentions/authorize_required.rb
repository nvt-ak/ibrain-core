# frozen_string_literal: true

module Ibrain
  module Extentions
    class AuthorizeRequired < GraphQL::Schema::FieldExtension
      def resolve(object:, arguments:, **rest)
        raise IbrainErrors::PermissionError.new("You not have permission to access #{field&.name}") unless is_authorized(object)

        # yield the current time as `memo`
        yield(object, arguments, rest)
      end

      private

      def is_authorized(object)
        required_roles = Ibrain::Config.authorize_resource_enabled_with_roles
        current_user = object.try(:context).try(:fetch, :current_user, nil)

        role = current_user.try(:role) || current_user.try(:graphql_role)

        return true unless required_roles.include?(role)

        current_user.try(:is_authorized?, field.name)
      end
    end
  end
end
