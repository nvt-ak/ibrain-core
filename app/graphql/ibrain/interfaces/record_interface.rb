# frozen_string_literal: true

module Ibrain::Interfaces::RecordInterface
  include Ibrain::Types::BaseInterface

  field :created_at, ::GraphQL::Types::ISO8601DateTime, null: false
  field :updated_at, ::GraphQL::Types::ISO8601DateTime, null: false
end
