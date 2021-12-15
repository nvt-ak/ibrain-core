# frozen_string_literal: true

module Ibrain
  module UserMethods
    extend ActiveSupport::Concern

    include Ibrain::UserApiAuthentication
    include Ibrain::UserReporting

    included do
      extend Ibrain::DisplayMoney
      after_create :auto_generate_ibrain_api_key

      include Ibrain::RansackableAttributes unless included_modules.include?(Ibrain::RansackableAttributes)
    end

    def auto_generate_ibrain_api_key
      return if !respond_to?(:ibrain_api_key) || ibrain_api_key.present?

      if Ibrain::Config.generate_api_key_for_all_roles || (ibrain_roles.map(&:name) & Ibrain::Config.roles_for_auto_api_key).any?
        generate_ibrain_api_key!
      end
    end
  end
end
