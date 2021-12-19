# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/named_base'
require_relative 'core'

module Ibrain
  module Graphql
    # TODO: What other options should be supported?
    #
    # @example Generate a `GraphQL::Schema::Resolver` by name
    #     rails g graphql:resolver PostsResolver
    class ResolverGenerator < Rails::Generators::Base
      include Core

      desc "Create a resolver by name"
      source_root File.expand_path('templates', __dir__)

      argument :name, type: :string

      def initialize(args, *options) # :nodoc:
        # Unfreeze name in case it's given as a frozen string
        args[0] = args[0].dup if args[0].is_a?(String) && args[0].frozen?
        super

        assign_names!(name)
      end

      attr_reader :file_name, :resolver_name, :field_name

      def create_resolver_file
        if @behavior == :revoke
          log :gsub, "#{options[:directory]}/types/query_type.rb"
        else
          create_resolver_root_type
        end

        template "resolver.erb", "#{options[:directory]}/resolvers/#{file_name}.rb"

        sentinel = /class .*QueryType\s*<\s*[^\s]+?\n/m
        in_root do
          gsub_file "#{options[:directory]}/types/query_type.rb", /  \# TODO: Add Resolvers as fields\s*\n/m, ""
          inject_into_file "#{options[:directory]}/types/query_type.rb", "    field :#{field_name}, resolver: Resolvers::#{resolver_name}\n", after: sentinel, verbose: false, force: false
        end
      end

      private

      def assign_names!(name)
        @field_name = name.camelize.underscore
        @resolver_name = name.camelize(:upper)
        @file_name = name.camelize.underscore
      end
    end
  end
end
