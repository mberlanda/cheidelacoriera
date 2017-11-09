# frozen_string_literal: truebookable_until

class ReservationsController < CrudController
  before_action :active_user?
  before_action :admin_user?, only: %i[approve_all show update edit]
  layout false, only: %i[user_form status]
  respond_to :html, :js

  self.permitted_attrs = %i[
    total_seats fan_names fan_ids notes
    status phone_number trip_id user_id
  ]

  include DatatableController

  def datatable_columns
    %i[trip_id user_id total_seats status fan_names phone_number notes]
  end

  def model_scope
    Reservation.includes(:user, :trip).all
  end

  def status
    @reservation = Reservation.find(params[:id])
  end

  def user_form
    event_id = params[:event_id]
    trip = Event.includes(:trip).find(event_id).trip
    render 'reservations/no_user_form', layout: false unless trip

    @reservation = Reservation.find_by(
      trip_id: trip.id, user_id: current_user.id
    )
    redirect_to action: :status, id: @reservation.id if @reservation

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
      redirect_to action: :status, id: @reservation.id
    else
      @fans = current_user.allowed_fans
      render 'reservations/user_form', layout: false
    end
  end

  def approve_all
    flash[:success] = t('controllers.reservations.approve_all.flash')
    Reservation.where(trip_id: params[:trip_id]).pending.approve_all
    redirect_to reservations_event_url(id: params[:id])
  end
end
