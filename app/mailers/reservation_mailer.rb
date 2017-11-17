# frozen_string_literal: true

class ReservationMailer < ApplicationMailer
  def received(reservation)
    @reservation = reservation
    @user = @reservation.user
  end
end
