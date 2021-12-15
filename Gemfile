# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

# Specify your gem's dependencies in ibrain-core.gemspec.
gemspec

platforms :jruby do
  gem 'jruby-openssl', require: false
  gem 'activerecord-jdbcsqlite3-adapter', require: false
end
