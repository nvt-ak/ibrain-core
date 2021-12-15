# frozen_string_literal: true

module Ibrain
  module Core
    module ControllerHelpers
      module Response
        extend ActiveSupport::Concern

        included do
          helper_method :render_json_error
          helper_method :render_json_ok
        end

        protected

        def render_json_error(error, status)
          e_message = error.try(:record).try(:errors).try(:full_messages).try(:first)
          e_message = error.try(:message) if e_message.blank?

          backtrace = error.try(:backtrace).try(:join, "\n")

          Ibrain::Logger.error e_message
          Ibrain::Logger.error backtrace

          render json: {
            errors: [{
              message: e_message,
              extensions: {
                code: status,
                exception: {
                  stacktrace: [
                    backtrace
                  ]
                }
              }
            }],
            message: e_message,
            data: nil
          }, status: status
        end

        def render_json_ok(data, message, errors = [])
          render json: {
            errors: errors,
            message: message || I18n.t('ibrain.system.message.ok'),
            data: data.as_json
          }, status: :ok
        end
      end
    end
  end
end
