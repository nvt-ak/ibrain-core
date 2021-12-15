# frozen_string_literal: true

module IbrainHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :standard_handler
    rescue_from ActionController::ParameterMissing, with: :parameter_handler
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_handler
    rescue_from ActiveRecord::RecordInvalid, with: :bad_request_handler
    rescue_from IbrainErrors::PermissionError, with: :permission_denied_handler
    rescue_from IbrainErrors::UnknownError, with: :bad_request_handler
    rescue_from ActionController::InvalidAuthenticityToken, with: :unauthorized_handler
    rescue_from ActiveSupport::MessageVerifier::InvalidSignature, with: :unauthorized_handler
  end

  private

  def standard_handler(errors)
    render_json_error(errors, 500)
  end

  def bad_request_handler(errors)
    render_json_error(errors, 400)
  end

  def parameter_handler(errors)
    render_json_error(errors, 400)
  end

  def not_found_handler(errors)
    render_json_error(errors, 404)
  end

  def permission_denied_handler(errors)
    render_json_error(errors, 405)
  end

  def unauthorized_handler(errors)
    render_json_error(errors, 401)
  end
end
