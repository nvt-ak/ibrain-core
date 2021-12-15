# frozen_string_literal: true

Ibrain::Core::Engine.routes.draw do
  namespace :api do
    namespace Ibrain::Config.api_version do
      resources :graphql do
        collection do
          post '/', action: :execute
        end
      end
    end
  end
end
