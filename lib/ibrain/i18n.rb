# frozen_string_literal: true

require 'i18n'

module Ibrain
  def self.i18n_available_locales
    I18n.available_locales.select do |locale|
      I18n.t('ibrain.i18n.this_file_language', locale: locale, fallback: false, default: nil)
    end
  end

  # This value is used as a count for the pluralization helpers related to I18n
  # ex: Ibrain::Order.model_name.human(count: Ibrain::I18N_GENERIC_PLURAL)
  # Related to Ibrain issue #1164, this is needed to avoid problems with
  # some pluralization calculators
  I18N_GENERIC_PLURAL = 2.1
end
