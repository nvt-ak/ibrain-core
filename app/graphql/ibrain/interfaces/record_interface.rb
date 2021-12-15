# frozen_string_literal: true

module Ibrain::Interfaces::RecordInterface
  include Ibrain::Types::BaseInterface

  graphql_name('RecordInterface')

  description 'Common Interface'

  field :id, ID, null: false
  field :created_at, ::GraphQL::Types::ISO8601DateTime, null: false, camelize: false
  field :updated_at, ::GraphQL::Types::ISO8601DateTime, null: false, camelize: false
end
