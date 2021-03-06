# frozen_string_literal: true

require 'ibrain/core/class_constantizer'

module Ibrain
  module Core
    module EnvironmentExtension
      extend ActiveSupport::Concern

      class_methods do
        def add_class_set(name)
          define_method(name) do
            set = instance_variable_get("@#{name}")
            set ||= send("#{name}=", [])
            set
          end

          define_method("#{name}=") do |klasses|
            set = ClassConstantizer::Set.new
            set.concat(klasses)
            instance_variable_set("@#{name}", set)
          end
        end
      end
    end
  end
end
