module Ibrain::Interfaces::PersonInterface
  include Ibrain::Types::BaseInterface

  graphql_name('PersonInterface')

  description 'Person Interface'

  field :first_name, String, null: true
  field :last_name, String, null: true
end