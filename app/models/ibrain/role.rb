# frozen_string_literal: true

module Ibrain
  class Role < Ibrain::Base
    has_many :role_users, class_name: "Ibrain::RoleUser", dependent: :destroy
    has_many :users, through: :role_users

    validates :name, uniqueness: { case_sensitive: true }

    def admin?
      name == "admin"
    end
  end
end
