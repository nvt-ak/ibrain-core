# frozen_string_literal: true

module Ibrain
  VERSION = "0.5.9"

  def self.ibrain_version
    VERSION
  end

  def self.ibrain_gem_version
    Gem::Version.new(ibrain_version)
  end
end
