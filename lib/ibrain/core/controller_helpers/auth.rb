# frozen_string_literal: true

module Ibrain
  module Core
    module ControllerHelpers
      module Auth
        extend ActiveSupport::Concern
        include Response

        # @!attribute [rw] fallback_on_unauthorized
        #   @!scope class
        #   Extension point for overriding behaviour of access denied errors.
        #   Default behaviour is to redirect back or to "/unauthorized" with a flash
        #   message.
        #   @return [Proc] action to take when access denied error is raised.

        included do
          before_action :set_guest_token
          helper_method :try_ibrain_current_user

          class_attribute :fallback_on_unauthorized
          self.fallback_on_unauthorized = -> do
            error = ::Struct.new(
              message: I18n.t('ibrain.authorization_failure')
                                     )

            render_json_error(error, :unauthorized)
          end

          rescue_from CanCan::AccessDenied do
            instance_exec(&fallback_on_unauthorized)
          end
        end

        # Needs to be overriden so that we use Brain's Ability rather than anyone else's.
        def current_ability
          @current_ability ||= Ibrain::Ability.new(try_ibrain_current_user)
        end

        def set_guest_token
          # if cookies.signed[:guest_token].blank?
          #   cookies.permanent.signed[:guest_token] = Ibrain::Config[:guest_token_cookie_options].merge(
          #     value: SecureRandom.urlsafe_base64(nil, false),
          #     httponly: true
          #   )
          # end
        end

        # proxy method to *possible* ibrain_current_user method
        # Authentication extensions (such as ibrain-auth) are meant to provide ibrain_current_user
        def try_ibrain_current_user
          # This one will be defined by apps looking to hook into Ibrain
          # As per authentication_helpers.rb
          if respond_to?(:ibrain_current_user, true)
            try(:ibrain_current_user)
          # This one will be defined by Devise
          elsif respond_to?(:current_ibrain_user, true)
            try(:current_ibrain_user)
          end
        rescue StandardError => e
          Ibrain::Logger.warn e.message.to_s

          nil
        end
      end
    end
  end
end
