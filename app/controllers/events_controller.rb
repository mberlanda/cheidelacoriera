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

  def reservations
    @event_id = params[:id]
    @event = Event.find(@event_id)
    @trip = @event.trip

    @models_label = I18n.t('activerecord.models.reservation.other')
    @model_name = 'reservation'
    @datatable_columns = %i[
      status total_seats user_id fan_names phone_number notes
    ]
  end
end
