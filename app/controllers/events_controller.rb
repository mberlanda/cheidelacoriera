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
  end

  def reservations
    @disable_subtitle = true
    @event_id = params[:id]
    @event = Event.friendly.find(@event_id)

    @models_label = I18n.t('activerecord.models.reservation.other')
    @model_name = 'reservation'
    @datatable_columns = %i[
      status total_seats user_id fan_names phone_number notes
    ]
  end

  def csv_reservations
    @event = Event.find(params[:id])
    respond_to do |format|
      format.csv { send_data @event.csv_reservations, filename: "#{@event.slug}.csv" }
    end
  end
end
