# frozen_string_literal: true

module Ibrain
  class BaseRepository
    def initialize(current_user, record)
      @current_user = current_user
      @record = record
    end

    attr_reader :current_user, :record

    protected

    def cryptor
      Ibrain::Encryptor.new
    end
  end
end
