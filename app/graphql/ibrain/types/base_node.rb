class Ibrain::Types::BaseNode < Types::BaseObject
  implements ::GraphQL::Relay::Node.interface
  implements ::Ibrain::Interfaces::RecordInterface

  global_id_field :id
  field_class ::Ibrain::Types::BaseField

  def self.field(*args, camelize: false, **kwargs, &block)
    super
  end
end
