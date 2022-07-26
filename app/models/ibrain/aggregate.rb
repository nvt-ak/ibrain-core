# frozen_string_literal: true

module Ibrain
  class Aggregate
    def initialize(count)
      @count = count
    end

    attr_reader :count
  end
end
