# frozen_string_literal: true

json.array! @actions.each_with_index do |action, url|
  json.key action
  json.name action
  json.url url
  json.iconClass t("home.index.panel.#{action}.icon_class")
  json.heading t("home.index.panel.#{action}.heading")
  json.body t("home.index.panel.#{action}.body").strip
  json.buttonText t('home.index.button.go')
end
