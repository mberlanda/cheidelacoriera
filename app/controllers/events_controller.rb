# frozen_string_literal: true

class EventsController < ApplicationController
  def upcoming
    @events = Event.upcoming
  end
end
