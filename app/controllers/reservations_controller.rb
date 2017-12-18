# frozen_string_literal: truebookable_until

class ReservationsController < CrudController
  before_action :authenticate_user!, only: %i[user_form]
  before_action :active_user?, except: %i[user_form]
  before_action :admin_user?, only: %i[approve_all show update edit]
  layout false, only: %i[user_form status]
  respond_to :html, :js

  self.permitted_attrs = [:phone_number, :notes, :status, :event_id, fan_names: []]

  include DatatableController

  def datatable_columns
    %i[event_id user_id total_seats status fan_names phone_number mail_sent notes]
  end

  def model_scope
    Reservation.includes(:user, :event).all
  end

  def status
    @reservation = Reservation.find(params[:id])
  end

  def user_form
    render 'reservations/rejected_user', layout: false if current_user.rejected?
    render 'reservations/pending_user', layout: false unless current_user.active?

    event_id = params[:event_id]
    @event = Event.find(event_id)
    render 'reservations/no_user_form', layout: false unless @event.book_range?

    @reservation = Reservation.find_by(
      event_id: event_id, user_id: current_user.id
    )
    redirect_to action: :status, id: @reservation.id if @reservation

    render 'reservations/no_user_form', layout: false unless current_user.can_book?(@event)

    @reservation = Reservation.new(
      event_id: event_id,
      fan_names: [current_user.full_name]
    )
  end

  def form_create
    permitted = params.require(:reservation)
                      .permit(:phone_number, :notes, :event_id, fan_names: [])
    @reservation = Reservation.new(
      event_id: permitted[:event_id],
      user_id: current_user.id,
      notes: permitted[:notes],
      phone_number: permitted[:phone_number],
      fan_names: permitted[:fan_names].to_a.reject(&:blank?)
    )
    @event = Event.find(permitted[:event_id])
    if @reservation.valid?
      @reservation.save
      ReservationMailer.received(@reservation).deliver_later
      redirect_to action: :status, id: @reservation.id
    else
      render 'reservations/user_form', layout: false
    end
  end

  def create
    permitted = params.require(:reservation)
                      .permit(:phone_number, :notes, :event_id, :user_id, fan_names: [])
    @reservation = Reservation.new(
      event_id: permitted[:event_id],
      user_id: permitted[:user_id],
      notes: permitted[:notes],
      phone_number: permitted[:phone_number],
      fan_names: permitted[:fan_names].to_a.reject(&:blank?)
    )
    if @reservation.valid?
      @reservation.save
      redirect_to @reservation
    else
      render action: :new
    end
  end

  def approve_all
    permitted = params.permit(:event_id, :id)
    flash[:success] = t('controllers.reservations.approve_all.flash')
    Reservation.where(event_id: permitted[:event_id]).pending.approve_all
    Event.find_by(Event.sanitize(permitted[:event_id])).recalculate_seats!
    redirect_to reservations_event_url(id: permitted[:id])
  end
end
