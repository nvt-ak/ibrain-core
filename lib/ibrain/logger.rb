# frozen_string_literal: true

module Ibrain
  class Logger
    class << self
      def info(message)
        Rails.logger.info("[Ibrain] #{message}")
      end

      def warn(message)
        Rails.logger.warn("[Ibrain] #{message}")
      end

      def debug(message)
        Rails.logger.debug { "[Ibrain] #{message}" }
      end

      def error(message)
        Rails.logger.error("[Ibrain] #{message}")
      end
    end
  end
end
