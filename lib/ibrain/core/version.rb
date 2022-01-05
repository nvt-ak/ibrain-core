# frozen_string_literal: true

module Ibrain
  VERSION = "0.2.0"

  def self.ibrain_version
    VERSION
  end

  def self.previous_ibrain_minor_version
    '0.1.9'
  end

  def self.ibrain_gem_version
    Gem::Version.new(ibrain_version)
  end
end
