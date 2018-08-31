# frozen_string_literal: true

class ReservationMailer < ApplicationMailer
  def received(reservation)
    mail_details(reservation)
    mail(
      to: @user.email,
      subject: "Richiesta Ricevuta | #{@event} | Chei De La Coriera"
    )
    @reservation.update(mail_sent: Time.zone.today)
  end

  def approved(reservation)
    mail_details(reservation)
    mail(
      to: @user.email,
      subject: "Richiesta Approvata | #{@event} | Chei De La Coriera"
    )
    @reservation.update(mail_sent: Time.zone.today)
  end

  def rejected(reservation)
    mail_details(reservation)
    mail(
      to: @user.email,
      subject: "Richiesta Declinata | #{@event} | Chei De La Coriera"
    )
    @reservation.update(mail_sent: Time.zone.today)
  end

  def overbooking(event)
    @event = event
    mail(
      to: 'cheidelacoriera@gmail.com',
      subject: "Disponibilità esaurita | #{@event}"
    )
  end

  private

  def mail_details(reservation)
    @reservation = reservation
    @user = @reservation.user
    @event = @reservation.event
  end
end
