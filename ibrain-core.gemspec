# frozen_string_literal: true

require_relative "lib/ibrain/core/version"

Gem::Specification.new do |spec|
  spec.name        = "ibrain-core"
  spec.version     = Ibrain.ibrain_version
  spec.authors     = ["Tai Nguyen Van"]
  spec.email       = ["nvt.tryup@gmail.com"]
  spec.homepage    = "https://techfox.io"
  spec.summary     = "Its Core is an sso authen gem for Ruby on Rails."
  spec.description = spec.summary
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/john-techfox/ibrain-core.git"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency 'activerecord-session_store', '~> 1.0'
  spec.add_dependency "awesome_nested_set", '~> 3.4.0'
  spec.add_dependency "cancancan", "~> 1.15.0"
  spec.add_dependency "friendly_id", "~> 5.4.2"
  spec.add_dependency "gem-release", '~> 2.2.2'
  spec.add_dependency "kaminari", "~> 1.2.1"
  spec.add_dependency 'puma', '~> 4.0'
  spec.add_dependency 'rack-cors', '~> 1.1.1'
  spec.add_dependency "rails", "~> 6.1.4", ">= 6.1.4.1"
  spec.add_dependency 'ransack', '~> 2.4.2'

  spec.metadata = {
    'rubygems_mfa_required' => 'true'
  }
end
