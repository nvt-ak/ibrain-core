# frozen_string_literal: true

module Ibrain
  # @private
  class CustomUserGenerator < Rails::Generators::NamedBase
    desc "Set up a Ibrain installation with a custom User class"
    source_root File.expand_path('templates', File.dirname(__FILE__))

    def check_for_constant
      klass
    rescue NameError
      @shell.say "Couldn't find #{class_name}. Are you sure that this class exists within your application and is loaded?", :red
    end

    def generate
      template 'authentication_helpers.rb.tt', "lib/ibrain/authentication_helpers.rb"

      file_action = File.exist?('config/initializers/ibrain.rb') ? :append_file : :create_file
      send(file_action, 'config/initializers/ibrain.rb') do
        "Rails.application.config.to_prepare do\n  require_dependency 'ibrain/authentication_helpers'\nend\n"
      end

      gsub_file 'config/initializers/ibrain.rb', /Ibrain\.user_class.?=.?.+$/, %{Ibrain.user_class = "#{class_name}"}
    end

    private

    def klass
      class_name.constantize
    end

    def table_name
      klass.table_name
    end
  end
end
