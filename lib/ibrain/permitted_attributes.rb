# frozen_string_literal: true

module Ibrain
  # Ibrain::PermittedAttributes contains the attributes permitted through strong
  # params in various controllers in the frontend. Extensions and stores that
  # need additional params to be accepted can mutate these arrays to add them.
  module PermittedAttributes
    ATTRIBUTES = [
      :address_attributes,
      :user_attributes
    ]

    mattr_reader(*ATTRIBUTES)

    @@address_attributes = [
      :id, :name, :address1, :address2, :city, :country_id, :state_id,
      :zipcode, :phone, :state_name, :province_id, :ward_id, :district_id
    ]

    # Intentionally leaving off email here to prevent privilege escalation
    # by changing a user with higher priveleges' email to one a lower-priveleged
    # admin owns. Creating a user with an email is handled separate at the
    # controller level.
    @@user_attributes = [:name, :email, :provider, :uid, :first_name, :last_name, :password, :password_confirmation]
  end
end
