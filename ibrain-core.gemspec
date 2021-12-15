# frozen_string_literal: true

require_relative "lib/ibrain/core/version"

Gem::Specification.new do |spec|
  spec.name        = "ibrain-core"
  spec.version     = Ibrain.ibrain_version
  spec.authors     = ["Tai Nguyen Van"]
  spec.email       = ["tainv@its-global.vn"]
  spec.homepage    = "https://its-global.vn"
  spec.summary     = "Its Core is an sso authen gem for Ruby on Rails."
  spec.description = spec.summary
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://gitlab.com/its-global/ibrain/ruby/ibrain-core"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "awesome_nested_set", '~> 3.4.0'
  spec.add_dependency "cancancan", "~> 1.15.0"
  spec.add_dependency "friendly_id", "~> 5.4.2"
  spec.add_dependency "kaminari", "~> 1.2.1"
  spec.add_dependency "rails", "~> 6.1.4", ">= 6.1.4.1"
  spec.add_dependency "puma", '~> 5.0'
  spec.add_dependency 'rack-cors', '~> 1.1.1'
  spec.add_dependency 'ransack', '~> 2.4.2'
  spec.add_dependency 'activerecord-session_store', '~> 1.0'
  spec.add_dependency 'annotate', '~> 3.1.1'
  spec.add_dependency 'dotenv', '~> 2.4'

  spec.add_development_dependency 'dotenv-rails'
  spec.add_development_dependency 'gem-that-requires-env-variables'

  if ENV['GRAPHQL_ENABLE']
    spec.add_dependency 'graphql', '~> 1.13.1'
    spec.add_dependency 'graphql-batch', '~> 0.4.3'
    spec.add_dependency 'graphql-guard', '~> 2.0.0'
    spec.add_dependency 'graphql-rails-generators', '~> 1.1.2'
  end

  if /sqlite/.match?(ENV['DATABASE_ADAPTER'])
    spec.add_dependency 'sqlite3'
    spec.add_dependency 'fast_sqlite'
  elsif /postgres/.match?(ENV['DATABASE_ADAPTER'])
    spec.add_dependency 'pg', '~> 1.1'
  else
    spec.add_dependency 'mysql2', '~> 0.5.2'
  end

  if /sendgrid/.match?(ENV['EMAIL_PROVIDER'])
    spec.add_dependency 'sendgrid-ruby', '~> 6.6.0'
  end

  if /ridgepole/.match?(ENV['MIGRATION_ENGINE'])
    spec.add_dependency 'ridgepole', '~> 0.9.6'
  end
end
