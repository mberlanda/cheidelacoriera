# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :active_user?

  def upcoming
    @events = Event.include_all.order(:date).upcoming
  end

  def all
    @events = Event.include_all.order(:date).all
  end

  def details
    @event = Event.include_all.find(params.require(:id))
  end
end
