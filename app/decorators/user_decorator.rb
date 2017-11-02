# frozen_string_literal: true

class UserDecorator < ApplicationDecorator
  def datatable_index
    [
      link_to(object.email, user_url(object.id)),
      object.status,
      object.role
    ]
  end
end
