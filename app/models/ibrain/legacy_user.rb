# frozen_string_literal: true

module Ibrain
  # Default implementation of User.
  #
  # @note This class is intended to be modified by extensions (ex.
  #   ibrain-auth)
  class LegacyUser < Ibrain::Base
    include Ibrain::UserMethods

    self.table_name = 'ibrain_users'

    def self.model_name
      ActiveModel::Name.new Ibrain::LegacyUser, Ibrain, 'user'
    end

    attr_accessor :password, :password_confirmation
  end
end
