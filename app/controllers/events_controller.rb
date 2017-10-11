# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :active_user?

  def upcoming
    @events = Event.upcoming
  end
end
