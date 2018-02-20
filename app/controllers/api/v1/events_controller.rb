# frozen_string_literal: true

class Api::V1::EventsController < ApplicationController
  skip_before_action :authenticate_user!
  layout false

  def upcoming
    @events = Event.include_all.order(:date).upcoming
    render_event_list
  end

  def index
    @events = Event.include_all.order(date: :desc).all
    render_event_list
  end

  def render_event_list
    respond_to do |format|
      format.json { render 'api/v1/events/list' }
    end
  end
end
