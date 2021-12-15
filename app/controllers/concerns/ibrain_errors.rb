# frozen_string_literal: true

module IbrainErrors
  extend ActiveSupport::Concern

  class PermissionError < StandardError; end

  class UnknownError < StandardError
    def initialize(message)
      super

      @message = message
    end

    def details
      message
    end

    private

    attr_accessor :message
  end
end
