# frozen_string_literal: true

Ibrain::Core::Engine.routes.draw do
  if ::Ibrain::Config.api_version.blank?
    post '/api/graphql', to: 'graphql#execute'
  else
    post "/api/#{::Ibrain::Config.api_version.downcase}/graphql", controller: 'graphql', action: 'execute'
  end
end
