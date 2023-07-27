# frozen_string_literal: true

class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!

  FACEBOOK_GROUP_URL = "https://www.facebook.com/groups/588161717946822/".freeze

  def index
    menu_actions
  end

  def regolamento; end

  def menu_actions
    default = current_user ? {} : { login: new_user_session_path }
    @actions = default.merge(
      upcoming_events: upcoming_events_path,
      facebook: FACEBOOK_GROUP_URL,
      news: news_index_path,
      posts: all_posts_path,
      photogallery: all_albums_path,
      regolamento: regolamento_path
    ).map(&build_action)
  end

  private

  def build_action
    lambda do |action, url|
      {
        name: action,
        url: url,
        iconClass: t("home.index.panel.#{action}.icon_class"),
        heading: t("home.index.panel.#{action}.heading"),
        body: t("home.index.panel.#{action}.body").strip,
        buttonText: t('home.index.button.go')
      }
    end
  end
end
