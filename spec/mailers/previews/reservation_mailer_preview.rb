# frozen_string_literal: true

require 'factory_girl'
require 'ffaker'

# Preview all emails at http://localhost:3000/rails/mailers/reservation_mailer
class ReservationMailerPreview < ActionMailer::Preview
  def received
    reservation = FactoryGirl.create(
      :reservation,
      fan_names: ['Nome Cognome', 'Altro Partecipante']
    )
    ReservationMailer.received(reservation)
  end
end
