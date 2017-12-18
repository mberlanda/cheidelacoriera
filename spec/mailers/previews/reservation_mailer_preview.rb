# frozen_string_literal: true

require 'factory_girl'
require 'ffaker'

# rubocop:disable Lint/HandleExceptions
begin
  FactoryGirl.find_definitions
rescue FactoryGirl::DuplicateDefinitionError
end
# rubocop:enable Lint/HandleExceptions

# Preview all emails at http://localhost:3000/rails/mailers/reservation_mailer
class ReservationMailerPreview < ActionMailer::Preview
  def received
    begin
      reservation = FactoryGirl.create(
        :reservation,
        fan_names: ['Nome Cognome', 'Altro Partecipante']
      )
    rescue ArgumentError
      FactoryGirl.find_definitions
      reservation = FactoryGirl.create(
        :reservation,
        fan_names: ['Nome Cognome', 'Altro Partecipante']
      )
    end
    ReservationMailer.received(reservation)
  end

  def overbooking
    event = FactoryGirl.create(:event, transport_mean: :bus)
    ReservationMailer.overbooking(event)
  end
end
