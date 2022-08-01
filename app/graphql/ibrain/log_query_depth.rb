# frozen_string_literal: true

class Ibrain::LogQueryDepth < GraphQL::Analysis::AST::QueryDepth
  def result
    query_depth = super
    current_user = query.context[:current_user]
    message = <<-RUBY
      [GraphQL Query Depth]: #{query_depth}
      [UserName]: #{current_user.try(:name)}
      [UserID]: #{current_user.try(:id)}
    RUBY

    Rails.logger.info(message)
  end
end
