# frozen_string_literal: true

class NewsController < ApplicationController
  before_action :authenticate_user!
  before_action :active_user?
end
