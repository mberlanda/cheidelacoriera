# frozen_string_literal: true

class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  def index
    @actions = {
      fans: fans_path,
      upcoming_events: upcoming_events_path,
      news: news_index_path
    }
  end
end
