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

      def decode_attributes(attributes)
        attributes.each_key do |k|
          v = attributes[k]

          if k.include?('attributes')
            unless v.is_a?(Array)
              attributes[k] = decode_attributes(v)

              next
            end

            attributes[k] = v.map do |e_attributes|
              decode_attributes(e_attributes)
            end
          end

          next unless k.include?('id')

          if v.is_a?(Array)
            attributes[k] = v.map do |e_value|
              _, item_id = ::GraphQL::Schema::UniqueWithinType.decode(e_value)

              item_id
            end

            next
          end

          next unless v.is_a?(String)

          _, item_id = ::GraphQL::Schema::UniqueWithinType.decode(v)

          attributes[k] = item_id
        end

        attributes
      end

      def graphql_encode(type_definition, object)
        GraphQL::Schema::UniqueWithinType.encode(type_definition.name, object.try(:id))
      end

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
