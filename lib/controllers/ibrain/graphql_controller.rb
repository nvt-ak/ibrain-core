module Ibrain
  class GraphqlController < Ibrain::BaseController
    def execute
      query, variables, operation_name = normalize_entity

      result = schema.execute(
        query,
        variables: variables,
        context: {
          session: session,
          current_user: current_user
        },
        operation_name: operation_name
      )

      render_json_ok(result['data'], nil, result['errors'])
    end

    protected

    def normalize_entity
      query = params[:query]
      operation_name = params[:operationName]
      variables = prepare_variables(params[:variables])

      [query, variables, operation_name]
    end

    # Handle variables in form data, JSON body, or a blank value
    def prepare_variables(variables_param)
      case variables_param
      when String
        if variables_param.present?
          JSON.parse(variables_param) || {}
        else
          {}
        end
      when Hash
        variables_param
      when ActionController::Parameters
        variables_param.to_unsafe_hash # GraphQLRuby will validate name and type of incoming variables.
      when nil
        {}
      else
        raise ArgumentError, "Unexpected parameter: #{variables_param}"
      end
    end

    def schema
      Ibrain::Config.graphql_schema.safe_constantize
    end
  end
end