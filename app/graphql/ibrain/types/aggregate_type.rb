# frozen_string_literal: true

module Ibrain
  module Types
    class AggregateType < BaseObject
      field :total_count, Int, null: false, default_value: 0
    end
  end
end
