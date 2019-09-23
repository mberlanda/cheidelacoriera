# frozen_string_literal: truebookable_until

class ReservationsController < CrudController
  before_action :authenticate_user!, only: %i[user_form form_create]
  before_action :active_user?, except: %i[user_form form_create]
  before_action :admin_user?, only: %i[approve_all show update edit]

  # skip_before_action :verify_authenticity_token, only: %i[form_create]

  layout false, only: %i[user_form status]
  respond_to :html, :js

  self.permitted_attrs = [:phone_number, :notes, :status, :event_id, :total_seats, :user_id, :stop, fan_names: []]

  include DatatableController

  def datatable_columns
    %i[event_id user_id total_seats status fan_names phone_number mail_sent notes stop]
  end

  def model_scope
    Reservation.joins(:user).includes(
      event: %i[home_team away_team competition]
    ).select(%w[id] | datatable_columns, '"users"."email" AS "user_email"')
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
      fan_names: [current_user.form_name].compact
    )
  end

  def form_create
    permitted = params.require(:reservation)
                      .permit(:phone_number, :notes, :event_id, :stop,
                              :user_id, :fans_count, fan_names: %i[first_name last_name])
    # params.require(:reservation)
    #       .permit(:phone_number, :notes, :event_id, fan_names: [])

    fan_names = permitted[:fan_names].to_a.reject(&:blank?)
    fan_names.map! { |h| "#{h[:last_name]}|#{h[:first_name]}" } # if @react_form

    head 400 if params[:user_id].to_i != current_user.id

    @reservation = Reservation.new(
      event_id: permitted[:event_id],
      user_id: current_user.id,
      notes: permitted[:notes],
      phone_number: permitted[:phone_number],
      fan_names: fan_names,
      stop: permitted[:stop]
    )
    @event = Event.find(permitted[:event_id])
    if @reservation.valid?
      @reservation.save
      ReservationMailer.received(@reservation).deliver_later
      head 200
    else
      render json: { errors: @reservation.errors.messages }, status: :bad_request
    end
  end

  def create
    permitted = params.require(:reservation)
                      .permit(:phone_number, :notes, :stop, :event_id, :user_id, :fans_count, fan_names: [])
    @reservation = Reservation.new(
      event_id: permitted[:event_id],
      user_id: permitted[:user_id],
      notes: permitted[:notes],
      phone_number: permitted[:phone_number],
      stop: permitted[:stop],
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
    event_id = Event.sanitize(params.require(:event_id).to_i)
    slug = params.require(:slug).to_s
    flash[:success] = t('controllers.reservations.approve_all.flash')
    Reservation.where(event_id: event_id).pending.includes(:user, :event).approve_all
    Event.find(event_id).recalculate_seats!
    redirect_to reservations_event_url(slug)
  end
end
