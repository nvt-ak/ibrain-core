# frozen_string_literal: true

Ibrain::Core::Engine.routes.draw do
  match "/", controller: 'graphql', action: 'execute', via: [:options, :post]
end
