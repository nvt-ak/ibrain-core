# frozen_string_literal: true

module Ibrain
  class BaseController < Ibrain::Config.parent_controller.constantize
    include ActionController::Helpers
    include Ibrain::Core::ControllerHelpers::Response
    include Ibrain::Core::ControllerHelpers::StrongParameters
    include Ibrain::Core::ControllerHelpers::CurrentHost
    include Ibrain::Core::ControllerHelpers::Auth

    include IbrainErrors
    include IbrainHandler

    protected

    def cryptor
      Ibrain::Encryptor.new
    end
  end
end
