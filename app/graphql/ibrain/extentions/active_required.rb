# frozen_string_literal: true

module Ibrain
  module Extentions
    class ActiveRequired < GraphQL::Schema::FieldExtension
      def resolve(object:, arguments:, **rest)
        raise ActionController::InvalidAuthenticityToken, I18n.t('ibrain.errors.session.is_deactivated') unless is_activated(object)

        # yield the current time as `memo`
        yield(object, arguments, rest)
      end

      private

      def is_activated(object)
        current_user = object.try(:context).try(:fetch, :current_user, nil)
        current_user.try(:is_activated?)
      end
    end
  end
end
