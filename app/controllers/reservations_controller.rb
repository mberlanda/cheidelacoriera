# frozen_string_literal: truebookable_until

class ReservationsController < CrudController
  before_action :authenticate_user!, only: %i[user_form]
  before_action :active_user?, except: %i[user_form]
  before_action :admin_user?, only: %i[approve_all show update edit]
  layout false, only: %i[user_form status]
  respond_to :html, :js

  self.permitted_attrs = [:phone_number, :notes, :status, :event_id, :total_seats, :user_id, fan_names: []]

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

    @react_form = ENV['REACT_FORMS'] || true

    if @react_form
      default_fans_count = 1
      @reservation_form = {
        schema: ReservationSchema.jsonschema(maximum: @event.pax, default: default_fans_count),
        ui_schema: ReservationSchema.ui_schema,
        form_data: {
          authenticity_token: form_authenticity_token,
          event_id: event_id,
          user_id: current_user.id,
          phone_number: current_user.phone_number,
          fans_count: default_fans_count,
          fan_names: [ { first_name: current_user.first_name, last_name: current_user.first_name }],
        }
      }
    else
      @reservation = Reservation.new(
        event_id: event_id,
        fan_names: [current_user.form_name].compact
      )
    end
  end

  def form_create
    @react_form = ENV['REACT_FORMS'] || true

    permitted = if @react_form
                  params.require(:reservation)
                        .permit(:phone_number, :notes, :event_id, fan_names: %i(first_name last_name))
                else
                  params.require(:reservation)
                        .permit(:phone_number, :notes, :event_id, fan_names: [])
                end
    fan_names = permitted[:fan_names].to_a.reject(&:blank?)
    if @react_form
      fan_names.map!{ |h| "#{h[:last_name]}|#{h[:first_name]}" }
    end

    @reservation = Reservation.new(
      event_id: permitted[:event_id],
      user_id: current_user.id,
      notes: permitted[:notes],
      phone_number: permitted[:phone_number],
      fan_names: fan_names
    )
    @event = Event.find(permitted[:event_id])
    if @reservation.valid?
      @reservation.save
      ReservationMailer.received(@reservation).deliver_later
    end
  end

  def create
    permitted = params.require(:reservation)
                      .permit(:phone_number, :notes, :event_id, :user_id, :fans_count, fan_names: [])
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
    redirect_to controller: :events_controller, action: :details, id: event_id
  end

  def approve_all
    event_id = Event.sanitize(params.require(:event_id).to_i)
    slug = params.require(:slug).to_s
    flash[:success] = t('controllers.reservations.approve_all.flash')
    Reservation.where(event_id: event_id).pending.approve_all
    Event.find(event_id).recalculate_seats!
    redirect_to reservations_event_url(slug)
  end
end
