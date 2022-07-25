# frozen_string_literal: true

namespace :ridgepole do
  desc 'Apply database schema'
  task apply: :environment do
    databases = Rails.configuration.database_configuration.fetch(Rails.env, {}).keys
    primary_database = Ibrain::Config.master_database
    spec_option = databases.include?(primary_database) ? "--spec-name primary #{primary_database}" : ""

    ridgepole('--apply', "-E #{Rails.env}", "--file #{schema_file}", spec_option)
    Rake::Task['db:schema:dump'].invoke if Rails.env.development?
    Rake::Task['annotate_models'].invoke if Rails.env.development?
  end

  desc 'Export database schema'
  task export: :environment do
    ridgepole('--export', " #{Rails.env}", "--split", "--output #{schema_file}")

    FileUtils.mkdir_p(schema_dir) unless File.directory?(schema_dir)

    data = File.read(schema_file)
    updated_data = data.gsub!("require '", "require 'schemas/")

    File.open(schema_file, "w") { |file| file.puts updated_data }
    system("cp #{db_dir}/*.schema #{schema_dir} && rm #{db_dir}/*.schema")

    ActiveRecord::Base.connection.tables.each do |table_name|
      system("bundle exec rails generate ibrain:core:model #{table_name.classify}")
    end

    system("bundle exec annotate --models --exclude fixtures")
  end

  desc 'import seed data'
  task seed: :environment do
    path = Rails.root.join("db/seeds/#{Rails.env}.rb")
    path = path.sub(Rails.env, ENV.fetch('RAILS_ENV', 'development')) unless File.exist?(path)

    require path
  end

  private

  def db_dir
    Rails.root.join('db')
  end

  def schema_dir
    "#{db_dir}/schemas"
  end

  def schema_file
    "#{db_dir}/Schemafile"
  end

  def config_file
    Rails.root.join('config/database.yml')
  end

  def ridgepole(*options)
    command = ['bundle exec ridgepole', "--config #{config_file}"]
    system [command + options].join(' ')
  end
end
