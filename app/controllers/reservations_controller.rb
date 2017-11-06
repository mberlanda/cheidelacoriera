# frozen_string_literal: true

class ReservationsController < ApplicationController
  before_action :active_user?
  layout false, only: :user_form

  def user_form
    @fans = current_user.allowed_fans
    @reservation = Reservation.new
  end
end
