# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/named_base'
require_relative 'core'

module Ibrain
  module Graphql
    # TODO: What other options should be supported?
    #
    # @example Generate a `GraphQL::Schema::RelayClassicMutation` by name
    #     rails g graphql:mutation CreatePostMutation
    class MutationGenerator < Rails::Generators::Base
      include Core

      desc "Create a Relay Classic mutation by name"
      source_root File.expand_path('templates', __dir__)

      argument :name, type: :string
      class_option :model, type: :string, default: nil

      def initialize(args, *options) # :nodoc:
        # Unfreeze name in case it's given as a frozen string
        args[0] = args[0].dup if args[0].is_a?(String) && args[0].frozen?
        super

        assign_names!(name)
      end

      attr_reader :file_name, :mutation_name, :field_name, :model_name

      def create_mutation_file
        if @behavior == :revoke
          log :gsub, "#{options[:directory]}/types/mutation_type.rb"
        else
          create_mutation_root_type
        end

        if options[:model].present?
          system("bundle exec rails generate ibrain:graphql:object #{options[:model].downcase}")
        end

        template "mutation.erb", "#{options[:directory]}/mutations/#{file_name}.rb"

        sentinel = /class .*MutationType\s*<\s*[^\s]+?\n/m
        in_root do
          gsub_file "#{options[:directory]}/types/mutation_type.rb", /  \# TODO: Add Mutations as fields\s*\n/m, ""
          inject_into_file "#{options[:directory]}/types/mutation_type.rb", "    field :#{field_name}, mutation: Mutations::#{mutation_name}\n", after: sentinel, verbose: false, force: false
        end
      end

      private

      def assign_names!(name)
        @field_name = name.camelize.underscore
        @mutation_name = name.camelize(:upper)
        @file_name = name.camelize.underscore
        @model_name = options[:model].blank? ? 'Post' : options[:model].capitalize
      end
    end
  end
end
