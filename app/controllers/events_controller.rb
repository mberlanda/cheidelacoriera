# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :active_user?

  def upcoming
    @events = Event.include_all.upcoming
  end

  def all
    @events = Event.include_all.order(:date).all
  end
end
