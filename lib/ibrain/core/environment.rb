# frozen_string_literal: true

require 'ibrain/core/environment_extension'

module Ibrain
  module Core
    class Environment
      include EnvironmentExtension

      attr_accessor :preferences

      def initialize(ibrain_config)
        @preferences = ibrain_config
      end
    end
  end
end
