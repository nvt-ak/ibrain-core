module Ibrain
  module Types
    class BaseInputObject < GraphQL::Schema::InputObject
      argument_class Ibrain::Types::BaseArgument
    end
  end
end