# frozen_string_literal: true

module Ibrain
  class BaseSchema < ::GraphQL::Schema
    use GraphQL::Batch

    use GraphQL::Guard.new(
      policy_object: ::Ibrain::Config.graphql_policy.safe_constantize,
      not_authorized: ->(type, field) { raise IbrainErrors::PermissionError.new("You not have permission to access #{type}.#{field}") }
    )

    # Union and Interface Resolution
    def self.resolve_type(_abstract_type, _obj, _ctx)
      # TODO: Implement this function
      # to return the correct object type for `obj`
      raise(GraphQL::RequiredImplementationMissingError)
    end

    # Relay-style Object Identification:

    # Return a string UUID for `object`
    def self.id_from_object(object, type_definition, query_ctx)
      # Here's a simple implementation which:
      # - joins the type name & object.id
      # - encodes it with base64:
      # GraphQL::Schema::UniqueWithinType.encode(type_definition.name, object.id)
    end

    # Given a string UUID, find the object
    def self.object_from_id(id, query_ctx)
      # For example, to decode the UUIDs generated above:
      # type_name, item_id = GraphQL::Schema::UniqueWithinType.decode(id)
      #
      # Then, based on `type_name` and `id`
      # find an object in your application
      # ...
    end

    def self.field(*args, camelize: false, **kwargs, &block)
      # if camelize == false
      #   # Also make a camelized field:
      #   field(*args, camelize: false, **kwargs, &block)
      # end
      super
    end

    rescue_from(ActiveRecord::RecordNotFound) do |_err, _obj, _args, _ctx, field|
      # Raise a graphql-friendly error with a custom message
      raise GraphQL::ExecutionError, "#{field.type.unwrap.graphql_name} not found"
    end
  end
end
