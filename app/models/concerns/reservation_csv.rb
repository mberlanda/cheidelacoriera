# frozen_string_literal: true

require 'csv'

module ReservationCsv
  extend ActiveSupport::Concern

  CSV_HEADERS = %w[email telefono cognome nome status ultimo_aggiornamento fermata].freeze
  def csv_reservations
    lines = reservations
    CSV.generate do |csv|
      csv << CSV_HEADERS
      lines.each do |l|
        process_csv_line(csv, l)
      end
    end
  end

  private

  def process_csv_line(csv, l)
    email = l.user
    phone_number = l.phone_number
    status = l.status
    last_update = l.updated_at
    stop = l.stop
    l.fan_names.each do |n|
      last_name, first_name = n.split('|').map(&:strip)
      csv << [email, phone_number, last_name, first_name, status, last_update, stop]
    end
  end
end
