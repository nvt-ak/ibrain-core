# frozen_string_literal: true

module Ibrain
  module Extentions
    class SessionRequired < GraphQL::Schema::FieldExtension
      def resolve(object:, arguments:, **rest)
        if is_invalid_session(object)
          Device.find_by_token(device_token(object))&.destroy!
          raise ActionController::InvalidAuthenticityToken, I18n.t('ibrain.errors.session.invalid_session')
        end

        # yield the current time as `memo`
        yield(object, arguments, rest)
      end

      private

      def is_invalid_session(object)
        object.try(:context).try(:fetch, :current_user, nil).blank? && options.try(:fetch, :session_required, false)
      end

      def device_token(object)  
        object.try(:context).try(:fetch, :request, nil).headers["Device-token"]
      end
    end
  end
end
