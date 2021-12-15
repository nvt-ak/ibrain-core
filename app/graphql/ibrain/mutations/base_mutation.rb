# frozen_string_literal: true

module Ibrain
  module Mutations
    class BaseMutation < GraphQL::Schema::RelayClassicMutation
      # argument_class Types::BaseArgument
      field_class Types::BaseField
      input_object_class Types::BaseInputObject
      object_class Types::BaseObject

      argument :attribute, Types::AttributeType, required: false
      argument :attributes, [Types::AttributeType], required: false

      def resolve(args)
        @current_user = context[:current_user]

        @params = ::ActionController::Parameters.new(args)
      end

      protected

      attr_reader :current_user, :params

      def object_from_id(id)
        _, item_id = GraphQL::Schema::UniqueWithinType.decode(id)

        collection.find(item_id)
      end

      def upload_permitted
        %i[content_type headers original_filename tempfile]
      end

      def collection
        Kernel.const_get(model)
      end

      def cryptor
        ::Ibrain::Encryptor.new
      end

      class << self
        def graphql_name(ons = nil)
          split_names = name.split('::')

          return ons if split_names.size < 2

          split_names[1].to_s + split_names.try(:last).to_s
        end
      end

      private

      def model
        self.class.name.demodulize.gsub('Create', '').gsub('Update', '').gsub('Delete', '')
      end
    end
  end
end
