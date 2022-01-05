# frozen_string_literal: true

module Ibrain
  module Core
    class GraphqlController < ::Ibrain::BaseController
      include Devise::Controllers::ScopedViews

      before_action :authenticate_user!, unless: :skip_operations
      before_action :map_user_class_to_request

      helpers = %w(resource scope_name resource_name signed_in_resource
                   resource_class resource_params devise_mapping)
      helper_method(*helpers)

      def execute
        query, variables, operation_name = normalize_entity

        result = schema.execute(
          query,
          variables: variables,
          context: {
            session: session,
            current_user: try_ibrain_current_user,
            controller: self,
            request: request
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

      def map_user_class_to_request
        return if request.env['devise.mapping'].present?

        request.env['devise.mapping'] = Ibrain.user_class
      end
    end
  end
end
