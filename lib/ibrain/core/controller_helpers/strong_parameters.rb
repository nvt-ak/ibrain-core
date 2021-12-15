# frozen_string_literal: true

module Ibrain
  module Core
    module ControllerHelpers
      module StrongParameters
        def permitted_attributes
          Ibrain::PermittedAttributes
        end

        delegate(*Ibrain::PermittedAttributes::ATTRIBUTES,
                 to: :permitted_attributes,
                 prefix: :permitted)

        def permitted_user_attributes
          permitted_attributes.user_attributes
        end
      end
    end
  end
end
