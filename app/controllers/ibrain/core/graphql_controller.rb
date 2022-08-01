# frozen_string_literal: true

module Ibrain
  module Core
    class GraphqlController < ::Ibrain::BaseController
      include Devise::Controllers::ScopedViews

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
          operation_name: operation_name,
          max_depth: max_depth(operation_name)
        )

        render_json_ok(result['data'], nil, result['errors'])
      end

      protected

      def normalize_entity
        return [params[:query], prepare_variables(params[:variables]), params[:operationName]] if params[:variables].present?
        return [params[:query], prepare_variables(params[:variables]), 'IntrospectionQuery'] if params[:query].try(:include?, 'IntrospectionQuery')

        operations = prepare_variables(params[:operations])
        query = operations['query'] || params[:query]
        variables = operations['variables'] || params[:variables]
        operation_name = operations['operationName'] || params[:operationName]

        if params[:map].present?
          JSON.parse(params[:map]).each do |k, arguments|
            argument_name = arguments.try(:first).try(:split, '.').try(:second)
            next if argument_name.blank?

            file = params[k]

            if variables[argument_name].blank?
              variables[argument_name] = variables[argument_name].is_a?(Array) ? [file] : file

              next
            end

            unless variables[argument_name].is_a?(Array)
              variables[argument_name] = [variables[argument_name]]
            end

            variables[argument_name] = variables[argument_name].concat([file]).compact
          end
        end

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

      def max_depth(operation_name)
        operation_name == 'IntrospectionQuery' ? 100 : Ibrain::Config.graphql_max_depth
      end
    end
  end
end
