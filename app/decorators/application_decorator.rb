# frozen_string_literal: true

class ApplicationDecorator < Draper::Decorator
  include Draper::LazyHelpers
  include ActionView::Context
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::OutputSafetyHelper
  include ActionView::Helpers::UrlHelper
  delegate_all

  def status_field(object)
    tag.div(object.status, class: "status-#{object.status}")
  end

  def role_field(object)
    tag.div(object.role, class: "role-#{object.role}")
  end

  def bool_field(value)
    tag.div(value, class: "bool-#{value}")
  end
end
