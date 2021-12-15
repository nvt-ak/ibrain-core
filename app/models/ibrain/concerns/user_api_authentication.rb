# frozen_string_literal: true

module Ibrain
  module UserApiAuthentication
    def generate_ibrain_api_key!
      generate_ibrain_api_key
      save!
    end

    def generate_ibrain_api_key
      self.ibrain_api_key = SecureRandom.hex(24)
    end

    def clear_ibrain_api_key!
      clear_ibrain_api_key
      save!
    end

    def clear_ibrain_api_key
      self.ibrain_api_key = nil
    end
  end
end
