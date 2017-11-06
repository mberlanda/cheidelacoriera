# frozen_string_literal: true

module NavbarHelper
  def nav_opt(el, options = {})
    { class: 'gtm-nav', data: { action: el } }.deep_merge(options)
  end
end
