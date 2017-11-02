# frozen_string_literal: true

class ApplicationDecorator < Draper::Decorator
  include Draper::LazyHelpers
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::OutputSafetyHelper

  delegate_all
end
