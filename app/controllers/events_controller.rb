# frozen_string_literal: true

class EventsController < PublicController
  include PermissionsScopeHelper

  before_action :authenticate_user!, only: %i[reservations]
  before_action :admin_user?, only: :reservations
  # before_action :active_user?, only: :details

  def upcoming; end

  def all; end

  def details
    @event = Event.include_all.friendly.find(params.require(:id))
    @title = @event.to_s
    @meta_description = 'Trasferta ' + @title

    if current_user
      @reservation = Reservation.find_by(
        event_id: @event.id, user_id: current_user.id
      )

      # @react_form = ENV['REACT_FORMS'] || true

      # if @react_form
      default_fans_count = 1
      @reservation_form = {
        schema: ReservationSchema.jsonschema(
          maximum: @event.pax,
          default: default_fans_count,
          stops: @event.available_stops
        ),
        ui_schema: ReservationSchema.ui_schema,
        form_data: {
          event_id: @event.id,
          user_id: current_user.id,
          phone_number: current_user.phone_number,
          fans_count: default_fans_count,
          fan_names: [{ first_name: current_user.first_name, last_name: current_user.last_name }]
        }
      }
      # else
      #   @reservation ||= Reservation.new(
      #     event_id: @event.id,
      #     fan_names: [current_user.form_name].compact
      #   )
      # end
    end
  end

  def reservations
    @disable_subtitle = true
    @event_id = params[:id]
    @event = Event.friendly.find(@event_id)

    @models_label = I18n.t('activerecord.models.reservation.other')
    @model_name = 'reservation'
    @datatable_columns = %i[
      status total_seats user_id fan_names phone_number notes stop
    ]
  end

  def csv_reservations
    @event = Event.find(params[:id])
    respond_to do |format|
      format.csv { send_data @event.csv_reservations, filename: "#{@event.slug}.csv" }
    end
  end
end
