# frozen_string_literal: true

module Ibrain
  module Extentions
    class SessionRequired < GraphQL::Schema::FieldExtension
      def resolve(object:, arguments:, **rest)
        if is_invalid_session(object)
          remove_device_token(object)
          raise ActionController::InvalidAuthenticityToken, I18n.t('ibrain.errors.session.invalid_session')
        end

        # yield the current time as `memo`
        yield(object, arguments, rest)
      end

      private

      def is_invalid_session(object)
        object.try(:context).try(:fetch, :current_user, nil).blank? && options.try(:fetch, :session_required, false)
      end

      def remove_device_token(object)
        request = object.try(:context).try(:fetch, :request, nil)
        Ibrain.user_class.try(:remove_device_token, request) if request
      end
    end
  end
end
