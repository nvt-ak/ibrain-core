# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in ibrain-core.gemspec.
gemspec

platforms :jruby do
  gem 'jruby-openssl', require: false
  gem 'activerecord-jdbcsqlite3-adapter', require: false
end

group :utils do
  gem 'i18n-tasks', '~> 0.9', require: false
  gem 'rubocop', '~> 0.75.0', require: false
  gem 'rubocop-performance', '~> 1.4', require: false
  gem 'rubocop-rails', '~> 2.3', require: false
  gem 'gem-release', require: false
  gem 'pry'
  gem 'listen', '~> 3.3'
end