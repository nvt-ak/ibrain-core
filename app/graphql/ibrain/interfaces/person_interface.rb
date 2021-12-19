# frozen_string_literal: true

module Ibrain::Interfaces::PersonInterface
  include Ibrain::Types::BaseInterface

  description 'Person Interface'

  field :first_name, String, null: true
  field :last_name, String, null: true
  field :full_name, String, null: true

  def full_name
    [object.try(:first_name), object.try(:last_name)].compact.join(' ')
  end
end
