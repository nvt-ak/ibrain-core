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

      def resolve(args)
        @params = ::ActionController::Parameters.new(args)
      end

      protected

      attr_reader :params

      def upload_permitted
        %i[content_type headers original_filename tempfile]
      end

      def cryptor
        ::Ibrain::Encryptor.new
      end

      def current_user
        context[:current_user]
      end
    end
  end
end
