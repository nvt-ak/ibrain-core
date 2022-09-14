# frozen_string_literal: true

module Ibrain
  module Extentions
    class ActiveRequired < GraphQL::Schema::FieldExtension
      def resolve(object:, arguments:, **rest)
        raise ActionController::InvalidAuthenticityToken, I18n.t('ibrain.errors.session.is_deactivated') if is_invalid_session(object)

        # yield the current time as `memo`
        yield(object, arguments, rest)
      end

      private

      def is_activated(object)
        object.try(:context).try(:fetch, :current_user, nil).blank? && options.try(:fetch, :session_required, false)
      end
    end
  end
end
