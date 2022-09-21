# frozen_string_literal: true

module Ibrain
  module Types
    class BaseType < BaseObject
      class << self
        def graphql_name(name = "")
          return name if name.present?

          self.name.demodulize.gsub('Type', '').classify.constantize.table_name
        end
      end
    end
  end
end
