module Ibrain
  class BaseSchema < GraphQL::Schema
    use GraphQL::Batch

    use GraphQL::Guard.new(
      policy_object: ::Ibrain::Config.graphl_policy.safe_constantize,
      not_authorized: ->(type, field) { GraphQL::ExecutionError.new("Not authorized to access #{type}.#{field}") }
    )

    # Add built-in connections for pagination
    # use GraphQL::Pagination::Connections

    # Relay Object Identification:

    # Object Resolution
    def self.resolve_type(_type, _obj, _ctx)
      # TODO: Implement this function
      # to return the correct type for `obj`
      type_class = "::Types::#{object.class}Type".safe_constantize
      raise ArgumentError, "Cannot resolve type for class #{object.class.name}" if type_class.blank?

      type_class
    end

    # Return a string UUID for `object`
    def self.id_from_object(object, type_definition, _query_ctx)
      # Here's a simple implementation which:
      # - joins the type name & object.id
      # - encodes it with base64:
      GraphQL::Schema::UniqueWithinType.encode(type_definition.name, object.try(:id))
    end

    # Given a string UUID, find the object
    def self.object_from_id(id, _query_ctx)
      # For example, to decode the UUIDs generated above:
      _, item_id = GraphQL::Schema::UniqueWithinType.decode(id)
      #
      # Then, based on `type_name` and `id`
      # find an object in your application
      # ...

      item_id
    end
    
    rescue_from(ActiveRecord::RecordNotFound) do |_err, _obj, _args, _ctx, field|
      # Raise a graphql-friendly error with a custom message
      raise GraphQL::ExecutionError, "#{field.type.unwrap.graphql_name} not found"
    end

    graphql_definition
  end
end