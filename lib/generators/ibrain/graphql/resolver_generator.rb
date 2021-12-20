# frozen_string_literal: true

# frozen_string_literal: true'

require_relative 'resolvers_generator'

module Ibrain
  module Graphql
    # TODO: What other options should be supported?
    #
    # @example Generate a `GraphQL::Schema::Resolver` by name
    #     rails g graphql:resolver PostsResolver
    class ResolverGenerator < ResolversGenerator
      source_root File.expand_path('templates', __dir__)

      def create_resolver_file
        if @behavior == :revoke
          log :gsub, "#{options[:directory]}/types/query_type.rb"
        else
          create_resolver_root_type
        end

        if options[:model].present?
          system("bundle exec rails generate ibrain:graphql:object #{options[:model].downcase}")
        end

        template "resolver.erb", "#{options[:directory]}/resolvers/#{file_name}.rb"

        sentinel = /class .*QueryType\s*<\s*[^\s]+?\n/m
        in_root do
          gsub_file "#{options[:directory]}/types/query_type.rb", /  \# TODO: Add Resolvers as fields\s*\n/m, ""
          inject_into_file "#{options[:directory]}/types/query_type.rb", "    field :#{field_name}, resolver: Resolvers::#{resolver_name}\n\n", after: sentinel, verbose: false, force: false
        end
      end
    end
  end
end
