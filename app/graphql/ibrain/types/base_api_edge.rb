# frozen_string_literal: true

module Ibrain
  module Types
    class BaseApiEdge < Types::BaseObject
      # add `node` and `cursor` fields, as well as `node_type(...)` override
      include GraphQL::Types::Relay::EdgeBehaviors
    end
  end
end
