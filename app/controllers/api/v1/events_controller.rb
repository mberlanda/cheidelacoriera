# frozen_string_literal: true

class Api::V1::EventsController < ApplicationController
  skip_before_action :authenticate_user!
  layout false

  def upcoming
    @events = event_scope.order(:date).upcoming
    render_event_list
  end

  def index
    @events = event_scope.order(date: :desc).all
    render_event_list
  end

  def event_scope
    Event.includes(:competition, :home_team, :away_team)
  end

  def render_event_list
    respond_to do |format|
      format.json { render 'api/v1/events/list' }
    end
  end
end
