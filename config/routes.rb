# frozen_string_literal: true

Ibrain::Core::Engine.routes.draw do
  post "/", controller: 'graphql', action: 'execute'
end
