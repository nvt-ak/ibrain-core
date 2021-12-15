# frozen_string_literal: true

module Ibrain
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
