# frozen_string_literal: true

module Ibrain
  module PermissionSets
    class SuperUser < PermissionSets::Base
      def activate!
        can :manage, :all
      end
    end
  end
end
