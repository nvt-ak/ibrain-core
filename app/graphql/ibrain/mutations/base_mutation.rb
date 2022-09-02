# frozen_string_literal: true

module Ibrain
  module Mutations
    class BaseMutation < GraphQL::Schema::RelayClassicMutation
      argument_class Types::BaseArgument
      field_class Types::BaseField
      input_object_class Types::BaseInputObject
      object_class Types::BaseObject

      argument :attribute, Types::AttributeType, required: false
      argument :attributes, [Types::AttributeType], required: false

      def ready?(args)
        @params = ActionController::Parameters.new(
          args.to_h.with_indifferent_access.transform_keys(&:underscore)
        )
        @resource = load_resource
        true
      end

      protected

      attr_reader :params, :resource

      def upload_permitted
        %i[content_type headers original_filename tempfile]
      end

      def cryptor
        ::Ibrain::Encryptor.new
      end

      def current_user
        context[:current_user]
      end

      def controller
        context[:controller]
      end

      def session
        context[:session]
      end

      def request
        context[:request]
      end

      def graphql_return
        {
          returning: resource.reload
        }
      end

      def success_response
        {
          success: true
        }
      end

      def id_from_params
        params[:id]
      end

      def attribute_params
        params[:attributes].to_params
      rescue StandardError
        ActionController::Parameters.new({})
      end
    end
  end
end
