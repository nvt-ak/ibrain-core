# frozen_string_literal: true

require 'singleton'
require 'ibrain/core/class_constantizer'

module Ibrain
  # A class responsible for associating {Ibrain::Role} with a list of permission sets.
  #
  # @see Ibrain::PermissionSets
  #
  # @example Adding order, data, and user display to customer service users.
  #   Ibrain::RoleConfiguration.configure do |config|
  #     config.assign_permissions :customer_service, [
  #       Ibrain::PermissionSets::UserDisplay,
  #     ]
  #   end
  class RoleConfiguration
    # An internal structure for the association between a role and a
    # set of permissions.
    class Role
      attr_reader :name, :permission_sets

      def initialize(name, permission_sets)
        @name = name
        @permission_sets = Ibrain::Core::ClassConstantizer::Set.new
        @permission_sets.concat permission_sets
      end
    end

    attr_accessor :roles

    # Given a CanCan::Ability, and a user, determine what permissions sets can
    # be activated on the ability, then activate them.
    #
    # This performs can/cannot declarations on the ability, and can modify its
    # internal permissions.
    #
    # @param ability [CanCan::Ability] the ability to invoke declarations on
    # @param user [#roles] the user that holds the roles association.
    def activate_permissions!(ability, user)
      ibrain_roles = ['default'] | user.roles.map(&:name)
      applicable_permissions = Set.new

      ibrain_roles.each do |role_name|
        applicable_permissions |= roles[role_name].permission_sets
      end

      applicable_permissions.each do |permission_set|
        permission_set.new(ability).activate!
      end
    end

    # Not public due to the fact this class is a Singleton
    # @!visibility private
    def initialize
      @roles = Hash.new do |hash, name|
        hash[name] = Role.new(name, Set.new)
      end
    end

    # Assign permission sets for a {Ibrain::Role} that has the name of role_name
    # @param role_name [Symbol, String] The name of the role to associate permissions with
    # @param permission_sets [Array<Ibrain::PermissionSets::Base>, Set<Ibrain::PermissionSets::Base>]
    #   A list of permission sets to activate if the user has the role indicated by role_name
    def assign_permissions(role_name, permission_sets)
      name = role_name.to_s

      roles[name].permission_sets.concat permission_sets
      roles[name]
    end
  end
end
