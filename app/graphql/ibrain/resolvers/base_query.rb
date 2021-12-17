# frozen_string_literal: true

class Ibrain::Resolvers::BaseQuery < GraphQL::Schema::Resolver
  def current_user
    context[:current_user]
  end
end
