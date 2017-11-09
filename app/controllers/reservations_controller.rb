# frozen_string_literal: truebookable_until

class ReservationsController < ApplicationController
  before_action :active_user?
  layout false, only: %i[user_form show]
  respond_to :html, :js

  def show
    @reservation = Reservation.find(params[:id])
  end

  def user_form
    event_id = params[:event_id]
    trip = Event.includes(:trip).find(event_id).trip
    render 'reservations/no_user_form', layout: false unless trip

    @reservation = Reservation.find_by(
      trip_id: trip.id, user_id: current_user.id
    )
    redirect_to @reservation if @reservation

    @fans = current_user.allowed_fans
    @reservation = Reservation.new(trip_id: trip.id)
  end

  def create
    permitted = params.require(:reservation)
                      .permit(:phone_number, :notes, :trip_id, fan_ids: [])
    @reservation = Reservation.new(
      trip_id: permitted[:trip_id],
      user_id: current_user.id,
      notes: permitted[:notes],
      phone_number: permitted[:phone_number],
      fan_ids: permitted[:fan_ids].to_a.reject(&:blank?)
    )
    if @reservation.valid?
      @reservation.save
      redirect_to @reservation
    else
      @fans = current_user.allowed_fans
      render 'reservations/user_form', layout: false
    end
  end
end
