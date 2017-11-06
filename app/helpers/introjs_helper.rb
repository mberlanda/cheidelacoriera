# frozen_string_literal: true

module IntrojsHelper
  def navbar_intro(element)
    el = I18n.t("navbar.infojs.#{element}")
    class_attributes(el[:step], el[:intro]).merge('data-action' => element)
  end

  private

  def class_attributes(data_step, data_intro)
    { 'data-step' => data_step.to_s, 'data-intro' => data_intro }
  end
end
