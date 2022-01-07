# frozen_string_literal: true

module Ibrain
  module Extentions
    class SessionRequired < GraphQL::Schema::FieldExtension
      def resolve(object:, arguments:, **rest)
        raise ActionController::InvalidAuthenticityToken, I18n.t('ibrain.errors.session.invalid_session') if is_invalid_session(object)

        # yield the current time as `memo`
        yield(object, arguments, rest)
      end

      private

      def is_invalid_session(object)
        object.try(:contect).try(:fetch, :current_user, nil).blank? && options.try(:fetch, :session_required, false)
      end
    end
  end
end
