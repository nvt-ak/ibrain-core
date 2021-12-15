# frozen_string_literal: true

require 'ibrain/config'

module Ibrain
  module Core
    class Engine < ::Rails::Engine
      isolate_namespace Ibrain
      config.generators.api_only = true

      initializer "ibrain.environment", before: :load_config_initializers do |app|
        app.config.ibrain = Ibrain::Config.environment
      end
    end
  end
end
