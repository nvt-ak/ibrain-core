# frozen_string_literal: true

require 'discard'

module Ibrain
  module SoftDeletable
    extend ActiveSupport::Concern

    included do
      include Discard::Model
      self.discard_column = :deleted_at

      default_scope { kept }
    end
  end
end
