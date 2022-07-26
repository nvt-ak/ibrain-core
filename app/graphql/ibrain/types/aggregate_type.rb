# frozen_string_literal: true

module Ibrain
  module Types
    class AggregateType < BaseObject
      graphql_name 'aggregate'

      field :count, Int, null: false
    end
  end
end
