# frozen_string_literal: true

module Ibrain
  module Extentions
    class Roles < GraphQL::Schema::FieldExtension
      def after_resolve(object:, arguments:, **rest)
        raise IbrainErrors::PermissionError.new("You not have permission to access #{field&.name}") if is_invalid_role(object)

        # yield the current time as `memo`
        yield(object, arguments, rest)
      end

      private

      def is_invalid_role(object)
        roles = options.try(:fetch, :roles, [])
        current_user = object.try(:context).try(:fetch, :current_user, nil)
        role = current_user.try(:role) || current_user.try(:graphql_role)

        return if roles.blank?
        return true if current_user.blank?
        return false if roles.include?(role)
      end
    end
  end
end
