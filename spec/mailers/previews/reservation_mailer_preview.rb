# frozen_string_literal: true

require 'factory_girl'
require 'ffaker'
FactoryGirl.find_definitions

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
end
