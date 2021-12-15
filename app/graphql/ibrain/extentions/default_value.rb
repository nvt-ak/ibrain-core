module Ibrain
  module Extentions
    class DefaultValue < GraphQL::Schema::FieldExtension
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