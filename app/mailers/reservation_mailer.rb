# frozen_string_literal: true

class ReservationMailer < ApplicationMailer
  def received(reservation)
    @reservation = reservation
    @user = @reservation.user
    @event = @reservation.event

    mail(
      to: @user.email,
      subject: "Prenotazione Ricevuta | #{@event} | Chei De La Coriera"
    )
    @reservation.update(mail_sent: Date.today)
  end
end
