# frozen_string_literal: true

class UserDecorator < ApplicationDecorator
  def datatable_index
    [
      link_to(object.email, user_url(object.id)),
      object.first_name,
      object.last_name,
      object.phone_number,
      object.newsletter,
      object.mailing_listed,
      object.status,
      object.activation_date,
      object.role
    ]
  end
end
