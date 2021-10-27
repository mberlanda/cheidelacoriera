# frozen_string_literal: true

class DecoratorHelper
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers
  include Draper::LazyHelpers
  include ActionView::Context
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::OutputSafetyHelper
  include ActionView::Helpers::UrlHelper

  attr_accessor :cache

  def initialize
    @cache = {}
  end

  def status_field(status)
    cache["status::#{status}"] ||= content_tag :div, status, class: "status-#{status}"
  end

  def role_field(role)
    cache["status::#{role}"] ||= content_tag :div, role, class: "role-#{role}"
  end

  def bool_field(value)
    cache["bool::#{value}"] ||= content_tag :div, value, class: "bool-#{value}"
  end

  def users(object)
    [
      link_to(object.email, user_url(object.id, only_path: true)),
      object.first_name,
      object.last_name,
      status_field(object.status),
      role_field(object.role),
      object.phone_number,
      bool_field(object.newsletter),
      bool_field(object.mailing_listed),
      object.activation_date
    ]
  end
end
