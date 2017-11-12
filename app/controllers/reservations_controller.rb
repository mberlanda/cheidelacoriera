# frozen_string_literal: truebookable_until

class ReservationsController < CrudController
  before_action :active_user?
  before_action :admin_user?, only: %i[approve_all show update edit]
  layout false, only: %i[user_form status]
  respond_to :html, :js

  self.permitted_attrs = %i[
    total_seats fan_names fan_ids notes
    status phone_number event_id user_id
  ]

  include DatatableController

  def datatable_columns
    %i[event_id user_id total_seats status fan_names phone_number notes]
  end

  def model_scope
    Reservation.includes(:user, :event).all
  end

  def status
    @reservation = Reservation.find(params[:id])
  end

  def user_form
    event_id = params[:event_id]
    event = Event.find(event_id)
    render 'reservations/no_user_form', layout: false unless event.book_range?

    @reservation = Reservation.find_by(
      event_id: event_id, user_id: current_user.id
    )
    redirect_to action: :status, id: @reservation.id if @reservation

    @reservation = Reservation.new(
      event_id: event_id,
      fan_names: [current_user.full_name]
    )
  end

  def create
    permitted = params.require(:reservation)
                      .permit(:phone_number, :notes, :event_id, fan_names: [])
    @reservation = Reservation.new(
      event_id: permitted[:event_id],
      user_id: current_user.id,
      notes: permitted[:notes],
      phone_number: permitted[:phone_number],
      fan_names: permitted[:fan_names].to_a.reject(&:blank?)
    )
    if @reservation.valid?
      @reservation.save
      redirect_to action: :status, id: @reservation.id
    else
      render 'reservations/user_form', layout: false
    end
  end

  def approve_all
    flash[:success] = t('controllers.reservations.approve_all.flash')
    Reservation.where(event_id: params[:event_id]).pending.approve_all
    redirect_to reservations_event_url(id: params[:id])
  end
end
