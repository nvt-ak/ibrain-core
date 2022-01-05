# frozen_string_literal: true

module Ibrain
  module Policies
    class BasePolicy
      class << self
        def query_rules
          {
            '*': {
              guard: ->(_obj, _args, _ctx) { false }
            }
          }
        end

        def mutation_rules
          {
            '*': {
              guard: ->(_obj, _args, _ctx) { false }
            }
          }
        end

        def rules
          {
            'Types::QueryType' => query_rules,
            'Types::MutationType' => mutation_rules
          }.freeze
        end

        def roles
          Ibrain.user_class.roles.keys
        end

        def has_permission?(current_user, resource)
          return false if current_user.blank?
          return true if current_user.super_admin?

          current_user.try(:scope).to_s.split(',').include?(resource)
        end

        def guard(type, field)
          rules.dig(type.name, field, :guard)
        end

        def not_authorized_handler(type, field)
          rules.dig(type, field, :not_authorized) || rules.dig(type, :*, :not_authorized)
        end
      end
    end
  end
end
