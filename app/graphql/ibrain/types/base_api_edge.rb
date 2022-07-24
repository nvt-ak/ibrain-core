# frozen_string_literal: true

module Ibrain
  module Types
    class BaseApiEdge < GraphQL::Schema::Object
      # add `node` and `cursor` fields, as well as `node_type(...)` override
      include GraphQL::Types::Relay::EdgeBehaviors
    end
  end
end
