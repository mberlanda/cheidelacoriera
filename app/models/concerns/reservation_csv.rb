# frozen_string_literal: true

require 'csv'

module ReservationCsv
  extend ActiveSupport::Concern

  def csv_reservations
    lines = reservations
    CSV.generate do |csv|
      csv << %w[email telefono cognome nome]
      lines.each do |l|
        email = l.user
        phone_number = l.phone_number
        l.fan_names.each do |n|
          last_name, first_name = n.split('|').map(&:strip)
          csv << [email, phone_number, last_name, first_name]
        end
      end
    end
  end
end
