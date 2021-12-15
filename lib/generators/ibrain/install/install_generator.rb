# frozen_string_literal: true

require 'rails/generators'
require 'ibrain/logger'

module Ibrain
  # @private
  class InstallGenerator < Rails::Generators::Base
    CORE_MOUNT_ROUTE = "mount Ibrain::Core::Engine"

    class_option :user_class, type: :string
    class_option :with_authentication, type: :boolean, default: true
    class_option :with_rubocop, type: :boolean, default: true
    class_option :with_graphql, type: :boolean, default: false
    class_option :with_annotation, type: :boolean, default: true
    class_option :with_sendgrid, type: :boolean, default: false
    class_option :enforce_available_locales, type: :boolean, default: nil

    def self.source_paths
      paths = superclass.source_paths
      paths << File.expand_path('../templates', "../../#{__FILE__}")
      paths << File.expand_path('../templates', "../#{__FILE__}")
      paths << File.expand_path('templates', __dir__)
      paths.flatten
    end

    def additional_tweaks
      return unless File.exist? 'public/robots.txt'

      append_file "public/robots.txt", <<-ROBOTS.strip_heredoc
        User-agent: *
        Disallow: /user
        Disallow: /account
        Disallow: /api
        Disallow: /password
      ROBOTS
    end

    def create_overrides_directory
      empty_directory "app/overrides"
    end

    def configure_application
      application <<-RUBY
        # Load application's model / class decorators
        initializer 'ibrain.decorators' do |app|
          config.to_prepare do
            Dir.glob(Rails.root.join('app/**/*_decorator*.rb')) do |path|
              require_dependency(path)
            end
          end
        end
      RUBY

      if !options[:enforce_available_locales].nil?
        application <<-RUBY
          I18n.enforce_available_locales = #{options[:enforce_available_locales]}
        RUBY
      end
    end

    def plugin_install_preparation
      @plugins_to_be_installed = []
      @plugin_generators_to_run = []
    end

    def install_auth_plugin
      if options[:with_authentication] && (options[:auto_accept] || !no?("
        Ibrain has a default authentication extension that uses Devise.
        You can find more info at https://github.com/john-techfox/ibrain-auth.git.

        Would you like to install it? (Y/n)"))

        @plugins_to_be_installed << 'ibrain-auth' unless system('gem list | grep ibrain-auth')
        @plugin_generators_to_run << 'ibrain:auth:install'
      end
    end

    def run_bundle_install_if_needed_by_plugins
      @plugins_to_be_installed.each do |plugin_name|
        gem plugin_name
      end

      if options[:with_rubocop]
        append_gem('rubocop', '1.23.0', 'development')
        append_gem('rubocop-performance', '1.12.0', 'development')
        append_gem('rubocop-rails', '2.12.4', 'development')
      end

      if options[:with_graphql]
        append_gem('graphql', '1.13.1')
        append_gem('graphql-batch', '0.4.3')
        append_gem('graphql-guard', '2.0.0')
        append_gem('graphql-rails-generators', '1.1.2', 'development')
        append_gem('graphiql-rails', '1.8.0', 'development')
      end

      append_gem('annotate', '3.1.1', 'development') if options[:with_annotation]
      append_gem('sendgrid-ruby', '6.6.0') if options[:with_sendgrid]
      append_gem('ridgepole', '0.9.6', 'development') if options[:with_ridgepole]

      bundle_cleanly{ run "bundle install" } if @plugins_to_be_installed.any?
      run "spring stop" if defined?(Spring)

      @plugin_generators_to_run.each do |plugin_generator_name|
        generate plugin_generator_name.to_s
      end
    end

    def install_routes
      routes_file_path = File.join('config', 'routes.rb')
      unless File.read(routes_file_path).include? CORE_MOUNT_ROUTE
        insert_into_file routes_file_path, after: "Rails.application.routes.draw do\n" do
          <<-RUBY
            # This line mounts Ibrain's routes at the root of your application.
            # This means, any requests to URLs such as /graphql, will go to Ibrain::GraphqlController,
            # any requests to URLS such as /auth, will go to Ibrain::AuthController,
            # If you would like to change where this engine is mounted, simply change the :at option to something different.
            #
            # We ask that you don't use the :as option here, as Ibrain relies on it being the default of "ibrain"
            #{CORE_MOUNT_ROUTE}, at: '/'

            # Please contact to Tai Nguyen Van <tainv@its-global.vn> if you have any question?
          RUBY
        end
      end

      unless options[:quiet]
        Ibrain::Logger.info "*" * 50
        Ibrain::Logger.info "We added the following line to your application's config/routes.rb file:"
        Ibrain::Logger.info " "
        Ibrain::Logger.info "    #{CORE_MOUNT_ROUTE}, at: '/'"
      end
    end

    def add_files
      template 'config/initializers/ibrain.rb.tt', 'config/initializers/ibrain.rb'
      template 'config/initializers/cors.tt', 'config/initializers/cors.rb'
      template 'config/puma.tt', 'config/puma.rb'
      template '.rubocop.yml.tt', '.rubocop.yml' if options[:with_rubocop]
    end

    def complete
      unless options[:quiet]
        Ibrain::Logger.info "*" * 50
        Ibrain::Logger.info "Ibrain has been installed successfully. You're all ready to go!"
        Ibrain::Logger.info " "
        Ibrain::Logger.info "Enjoy!"
      end
    end

    private

    def bundle_cleanly(&block)
      Bundler.respond_to?(:with_unbundled_env) ? Bundler.with_unbundled_env(&block) : Bundler.with_clean_env(&block)
    end

    def append_gem(name, version, group_name = nil)
      shell_command = ["\ngem '#{name}', '~> #{version}'"]
      shell_command.push("group: :#{group_name}") if group_name.present?
      string_command = shell_command.join(', ')
      grep_command = "gem list | grep '#{name} (#{version})'"

      system( `echo "#{string_command}" >> Gemfile` ) unless system(grep_command)
    end
  end
end
