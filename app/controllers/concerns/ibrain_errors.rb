module IbrainErrors
  extend ActiveSupport::Concern

  class PermissionError < StandardError; end
  class UnknownError < StandardError
    def initialize(message)
      @message = message
    end

    def details
      message
    end

    private

    attr_accessor :message
  end
end
