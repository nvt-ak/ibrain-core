# frozen_string_literal: true

module Ibrain
  class RoleUser < Ibrain::Base
    belongs_to :role, class_name: "Ibrain::Role", optional: true
    belongs_to :user, class_name: Ibrain::UserClassHandle.new, optional: true

    after_create :auto_generate_ibrain_api_key

    validates :role_id, uniqueness: { scope: :user_id }

    private

    def auto_generate_ibrain_api_key
      user.try(:auto_generate_ibrain_api_key)
    end
  end
end
