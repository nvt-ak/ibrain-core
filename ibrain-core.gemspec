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
  spec.metadata["rubygems_mfa_required"] = 'true'

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency 'activerecord-session_store'
  spec.add_dependency "awesome_nested_set"
  spec.add_dependency "cancancan"
  spec.add_dependency 'discard'
  spec.add_dependency "gem-release"
  spec.add_dependency "kaminari"
  spec.add_dependency 'puma'
  spec.add_dependency 'rack-cors'
  spec.add_dependency "rails"
  spec.add_dependency 'ransack'
end
