# frozen_string_literal: true

module Ibrain
  module Extentions
    class DefaultValue < GraphQL::Schema::FieldExtension
      description 'Default value extention'

      def after_resolve(value:, **_rest)
        if value.nil?
          options[:default_value]
        else
          value
        end
      end
    end
  end
end
