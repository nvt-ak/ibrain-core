# frozen_string_literal: true

require "action_controller/railtie"
require "action_mailer/railtie"
require "active_job/railtie"
require "active_model/railtie"
require "active_record/railtie"
require "active_storage/engine"
require 'activerecord/session_store'

require 'awesome_nested_set'
require 'cancan'
require 'friendly_id'
require 'kaminari/activerecord'
require 'rack/cors'

module Ibrain
  mattr_accessor :user_class

  def self.user_class
    case @@user_class
    when Class
      raise "Ibrain.user_class MUST be a String or Symbol object, not a Class object."
    when String, Symbol
      @@user_class.to_s.constantize
    end
  end

  # Load the same version defaults for all available Ibrain components
  #
  # @see Ibrain::Preferences::Configuration#load_defaults
  def self.load_defaults(version)
    Ibrain::Config.load_defaults(version)
    Ibrain::Api::Config.load_defaults(version) if defined?(Ibrain::Api::Config)
  end

  # Used to configure Ibrain.
  #
  # Example:
  #
  #   Ibrain.config do |config|
  #     config.track_inventory_levels = false
  #   end
  #
  # This method is defined within the core gem on purpose.
  # Some people may only wish to use the Core part of Ibrain.
  def self.config(&_block)
    yield(Ibrain::Config)
  end

  module Core
    def self.does_ibrain_initializer_exist?(rails_paths, initializer_name)
      rails_paths['config/initializers'].any? do |path|
        File.exist?(Pathname.new(path).join(initializer_name))
      end
    end

    private_class_method :does_ibrain_initializer_exist?

    class GatewayError < RuntimeError; end
  end
end

require "ibrain/core/version"

require 'ibrain/core/class_constantizer'
require 'ibrain/core/environment_extension'
require 'ibrain/core/environment'

require "ibrain/core/engine"

require 'ibrain/i18n'
require 'ibrain/permitted_attributes'
require 'ibrain/permission_sets'
require 'ibrain/logger'

require 'ibrain/core/controller_helpers/response'
require 'ibrain/core/controller_helpers/current_host'
require 'ibrain/core/controller_helpers/strong_parameters'
require 'ibrain/core/controller_helpers/auth'
require 'ibrain/core/role_configuration'

require 'ibrain/core/validators/email'
require 'ibrain/user_class_handle'
require 'ibrain/encryptor'
