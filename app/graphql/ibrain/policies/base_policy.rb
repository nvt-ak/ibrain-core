module Ibrain
  module Policies
    class BasePolicy
      IBRAIN_QUERY_RULES = {
        '*': {
          guard: ->(_obj, _args, _ctx) { true }
        }
      }

      IBRAIN_MUTATION_RULES = {
        '*': {
          guard: ->(_obj, _args, ctx) { roles.include?(ctx[:current_user].try(:role)) }
        }
      }

      RULES = {
        'Query' => IBRAIN_QUERY_RULES,
        'Mutation' => IBRAIN_MUTATION_RULES
      }.freeze

      class << self
        def roles
          Ibrain::Config.ibrain_roles
        end

        def has_permission?(current_user, resource)
          return false if current_user.blank?
          return true if current_user.super_admin?

          current_user.try(:scope).to_s.split(',').include?(resource)
        end

        def guard(type, field)
          RULES.dig(type.name, field, :guard)
        end

        def not_authorized_handler(type, field)
          RULES.dig(type, field, :not_authorized) || RULES.dig(type, :'*', :not_authorized)
        end
      end
    end
  end
end