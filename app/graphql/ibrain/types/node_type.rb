# frozen_string_literal: true

module Ibrain
  module Types
    module NodeType
      include Ibrain::Types::BaseInterface
      # Add the `id` field
      include GraphQL::Types::Relay::NodeBehaviors
    end
  end
end
