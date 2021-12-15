module Ibrain
  module Types
    class BaseObject < GraphQL::Schema::Object
      field_class ::Ibrain::Types::BaseField
    end
  end
end