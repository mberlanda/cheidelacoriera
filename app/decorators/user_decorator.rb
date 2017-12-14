# frozen_string_literal: true

class UserDecorator < ApplicationDecorator
  def datatable_index
    [
      link_to(object.email, user_url(object.id)),
      object.first_name,
      object.last_name,
      status_field(object),
      role_field(object),
      object.phone_number,
      bool_field(object.newsletter),
      bool_field(object.mailing_listed),
      object.activation_date
    ]
  end
end
