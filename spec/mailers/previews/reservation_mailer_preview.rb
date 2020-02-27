# frozen_string_literal: true

require 'factory_bot'
require 'ffaker'
begin
  FactoryBot.find_definitions
rescue FactoryBot::DuplicateDefinitionError
end

# Preview all emails at http://localhost:3000/rails/mailers/reservation_mailer
class ReservationMailerPreview < ActionMailer::Preview
  def received
    begin
      reservation = FactoryBot.create(
        :reservation,
        fan_names: ['Nome Cognome', 'Altro Partecipante']
      )
    rescue ArgumentError
      FactoryBot.find_definitions
      reservation = FactoryBot.create(
        :reservation,
        fan_names: ['Nome Cognome', 'Altro Partecipante']
      )
    end
    ReservationMailer.received(reservation)
  end

  def overbooking
    event = FactoryBot.create(:event, transport_mean: :bus)
    ReservationMailer.overbooking(event)
  end
end
