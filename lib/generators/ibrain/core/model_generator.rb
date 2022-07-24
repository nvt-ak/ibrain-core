# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/named_base'
require 'rails/generators/base'
require 'active_support'
require 'active_support/core_ext/string/inflections'

module Ibrain
  module Core
    class ModelGenerator < Rails::Generators::Base
      desc "Create a model by name"
      source_root File.expand_path('templates', __dir__)

      argument :name, type: :string

      def initialize(args, *options) # :nodoc:
        # Unfreeze name in case it's given as a frozen string
        args[0] = args[0].dup if args[0].is_a?(String) && args[0].frozen?
        super

        assign_names!(name)
      end

      attr_reader :file_name

      def create_model_file
        template "model.erb", "app/models/#{file_name}.rb"
      end

      private

      def assign_names!(name)
        @file_name = name.underscore
      end
    end
  end
end
