# frozen_string_literal: true

# This is the primary location for defining ibrain preferences
#
# The expectation is that this is created once and stored in
# the ibrain environment
#
# setters:
# a.color = :blue
# a[:color] = :blue
# a.set :color = :blue
# a.preferred_color = :blue
#
# getters:
# a.color
# a[:color]
# a.get :color
# a.preferred_color
#
require 'ibrain/preferences/configuration'
require 'ibrain/core/environment'

module Ibrain
  class AppConfiguration < Preferences::Configuration
    # Preferences (alphabetized to more easily lookup particular preferences)

    # @!attribute [rw] guest_token_cookie_options
    #   @return [Hash] Add additional guest_token cookie options here (ie. domain or path)
    preference :guest_token_cookie_options, :hash, default: {}

    # @!attribute [rw] generate_api_key_for_all_roles
    #   @return [Boolean] Allow generating api key automatically for user
    #   at role_user creation for all roles. (default: +false+)
    preference :generate_api_key_for_all_roles, :boolean, default: false

    # @!attribute [rw] mails_from
    #   @return [String] Email address used as +From:+ field in transactional emails.
    preference :mails_from, :string, default: 'ibrain@example.com'

    preference :graphql_policy, :string, default: 'Ibrain::Policies::GraphqlPolicy'

    # Api version for route config
    preference :api_version, :string, default: 'v1'

    # Graphql Schema name
    preference :graphql_schema, :string, default: 'Ibrain::BaseSchema'

    # Graphql Encryptor key
    preference :ibrain_encryptor_key, :string, default: nil

    # Parent controller
    preference :parent_controller, :string, default: 'ActionController::API'

    preference :master_database, :string, default: 'primary'

    preference :graphql_max_depth, :integer, default: 3

    preference :is_auto_append_mutation, :boolean, default: true

    preference :is_require_activated_account, :boolean, default: false

    # Enabled authorize resource by user
    preference :authorize_resource_enabled_with_roles, :array, default: []

    def static_model_preferences
      @static_model_preferences ||= Ibrain::Preferences::StaticModelPreferences.new
    end

    def roles
      @roles ||= Ibrain::RoleConfiguration.new.tap do |roles|
        roles.assign_permissions :default, ['Ibrain::PermissionSets::DefaultCustomer']
        roles.assign_permissions :admin, ['Ibrain::PermissionSets::SuperUser']
      end
    end

    def environment
      @environment ||= Ibrain::Core::Environment.new(self)
    end
  end
end
