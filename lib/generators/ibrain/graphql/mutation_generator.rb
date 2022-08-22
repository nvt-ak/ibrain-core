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
      class_option :prefix, type: :string, default: nil

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
          system("bundle exec rails generate ibrain:graphql:object #{options[:model].underscore}")
        end

        template "mutation.erb", "#{options[:directory]}/mutations/#{file_name}.rb"
        return unless ::Ibrain::Config.is_auto_append_mutation

        in_root do
          gsub_file "#{options[:directory]}/types/mutation_type.rb", /  \# TODO: Add Mutations as fields\s*\n/m, ""
          inject_into_file "#{options[:directory]}/types/mutation_type.rb", "\n    field :#{field_name}, mutation: Mutations::#{mutation_name} \n  ", before: "end\nend", verbose: true, force: true
        end
      end

      private

      def assign_names!(name)
        underscore_name = name&.camelize&.underscore
        prefix = options[:prefix].try(:underscore)
        @model_name = options[:model].blank? ? 'Post' : options[:model].try(:camelize, :upper)

        if prefix.blank?
          @mutation_name = name.camelize(:upper)
          @file_name = underscore_name
          @field_name = underscore_name

          return
        end

        @mutation_name = "#{prefix.try(:camelize, :upper)}::#{name.camelize(:upper)}"
        @file_name = "#{prefix}/#{underscore_name}"
        @field_name = "#{prefix}_#{underscore_name}"
      end
    end
  end
end
