# frozen_string_literal: true

class Ibrain::Types::BaseNode < Ibrain::Types::BaseObject
  include ::GraphQL::Relay::Node
  implements ::Ibrain::Interfaces::RecordInterface

  global_id_field :id
  field_class ::Ibrain::Types::BaseField

  def self.field(*args, camelize: false, **kwargs, &block)
    super
  end
end
