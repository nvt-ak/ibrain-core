# frozen_string_literal: true

class Ibrain::Base < Ibrain::ApplicationRecord
  include ActionView::Helpers::DateHelper

  self.abstract_class = true

  def string_id
    try(:id).try(:to_s)
  end

  scope :graphql_ransack, lambda { |params|
    ransack(params).result
  }

  scope :reverse_scope, lambda {
    order(created_at: :desc)
  }

  scope :ransack_query, lambda { |params, page, per_page = 10|
    ransack(params).
      result.
      page(page).
      per(per_page)
  }

  def cryptor
    ::Ibrain::Encryptor.new
  end

  def created_in_word
    time_ago_in_words(created_at)
  end

  class << self
    # Provides a scope that should be included any time data
    # are fetched with the intention of displaying to the user.
    #
    # Allows individual stores to include any active record scopes or joins
    # when data are displayed.
    def display_includes
      where(nil)
    end

    def paginate(args)
      limit(args[:limit]).offset(args[:offset])
    end

    def adjust_date_for_cdt(datetime)
      datetime.in_time_zone('UTC')
    end
  end
end
