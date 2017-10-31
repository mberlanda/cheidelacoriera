# frozen_string_literal: true

class UserDecorator < Drape::Decorator
  include Drape::LazyHelpers
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::OutputSafetyHelper

  delegate_all

  def datatable_index
    [
      link_to(object.email, user_url(object.id)),
      object.status,
      object.role
    ]
  end
end
