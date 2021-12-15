# frozen_string_literal: true

module Ibrain
  # == An ActiveModel Email Validator
  #
  # === Usage
  #
  #     require 'ibrain/core/validators/email'
  #
  #     class Person < ApplicationRecord
  #       validates :email_address, 'ibrain/email' => true
  #     end
  #
  class EmailValidator < ActiveModel::EachValidator
    EMAIL_REGEXP = URI::MailTo::EMAIL_REGEXP

    def validate_each(record, attribute, value)
      unless EMAIL_REGEXP.match? value
        record.errors.add(attribute, :invalid, **{ value: value }.merge!(options))
      end
    end
  end
end
